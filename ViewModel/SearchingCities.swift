//
//  Geocoding.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.01.2023.
//

import SwiftUI
import Combine

final class SearchingCities: ObservableObject {
    private let geocodingIP: GeocodingIpProtocol
    private let dataAutocomplete: DataAutocompleteProtocol
    private let location: LocationProtocol

    // Input
    @Published var city = ""
    @Published var isMyCity = false

    // Output
    @Published var myCity: Result<AutocompleteCityElement, Error>?
    @Published var autocompleteCities: Result<AutocompleteCities, Error>?
    @Published var mainCities: Result<AutocompleteCities, Error>?

    func getLocation(_ element: AutocompleteCityElement) -> Location {
        location.getLocation(element)
        }

    func stationName(_ stationId: String) -> String {
        location.stationName(stationId)
    }

    private func getCityForIP() -> AnyPublisher<AutocompleteCityElement, Error> {
        geocodingIP.getCity()
            .map {$0.name}
            .flatMap(dataAutocomplete.getAutocompleteCities)
            .filter {!$0.isEmpty}
            .map {$0.first!}
            .eraseToAnyPublisher()
    }

    init(
        geocodingIP: GeocodingIpProtocol = GeocodingIpModel(),
        dataAutocomplete: DataAutocompleteProtocol = AutocompleteModel(),
        location: LocationProtocol = LocationModel()
    ) {
        self.geocodingIP = geocodingIP
        self.dataAutocomplete = dataAutocomplete
        self.location = location

        $isMyCity
            .filter {$0}
            .map {_ in ()}
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
