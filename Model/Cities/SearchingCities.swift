//
//  Geocoding.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.01.2023.
//

import SwiftUI
import Combine

final class SearchingCities: ObservableObject {
    private let trainStationsAndRoutes: TrainStationsAndRoutesProtocol
    private let geocodingIP: GeocodingIpProtocol
    private let dataAutocomplete: DataAutocompleteProtocol

    private var allStations: [String: String] = [:]
    private var allTrainRoutes: [TrainRoute] = []

    // Input
    @Published var city = ""
    @Published var isMyCity = false

    // Output
    @Published var myCity: Result<AutocompleteCityElemnt, Error>?
    @Published var autocompleteCities: Result<AutocompleteCities, Error>?
    @Published var mainCities: Result<AutocompleteCities, Error>?

    func getLocation(_ element: AutocompleteCityElemnt) -> Location {
        var location = Location()

        location.name = element.name
        location.countryName = element.countryName
        location.codeIATA = element.code

        location.trainStationId = allStations.compactMap {
            $0.value.lowercased().contains(element.name.lowercased()) ? $0.key : nil
        }

        location.routes = allTrainRoutes.filter {
            $0.departureStationName.contains(element.name) || $0.arrivalStationName.contains(element.name)
        }

        return location
    }

    func stationName(_ stationId: String) -> String {
        let resultDict = allStations.first {$0.key == stationId}
        return resultDict?.value ?? "No Name"
    }

    private func getCityForIP() -> AnyPublisher<AutocompleteCityElemnt, Error> {
        geocodingIP.getCity()
            .map {$0.name}
            .flatMap(dataAutocomplete.getAutocompleteCities)
            .filter {!$0.isEmpty}
            .map {$0.first!}
            .eraseToAnyPublisher()
    }

    init(
        trainStationsAndRoutes: TrainStationsAndRoutesProtocol = TrainStationsAndRoutes(inputFile: "tutu_routes.csv"),
        geocodingIP: GeocodingIpProtocol = GeocodingIP(),
        dataAutocomplete: DataAutocompleteProtocol = Autocomplete()
    ) {
        self.trainStationsAndRoutes = trainStationsAndRoutes
        self.geocodingIP = geocodingIP
        self.dataAutocomplete = dataAutocomplete

        allStations = trainStationsAndRoutes.getTrainStationsNames()
        allTrainRoutes = trainStationsAndRoutes.getTrainRoutes()

        $isMyCity
            .filter {$0}
            .flatMap {_ in Just(())}
            .flatMap(getCityForIP)
            .asResult()
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$myCity)

        $city
            .debounce(for: 0.6, scheduler: DispatchQueue.main)
            .map {!$0.isEmpty ? $0 : "Россия"}
            .map(dataAutocomplete.getAutocompleteCities)
            .switchToLatest()
            .asResult()
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$autocompleteCities)
    }
}


