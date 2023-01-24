//
//  Geocoding.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.01.2023.
//

import SwiftUI
import Combine

struct Location: Identifiable {
    var id = UUID()
    var name: String = ""
    var countryName: String = ""
    var codeIATA: String = ""
    var trainStationId: [String] = []
    var routes: [TrainRoute] = []
}

final class SearchingCities: ObservableObject {
    private var trainStationsAndRoutes: TrainStationsAndRoutesProtocol
    private var geocodingIP: GeocodingIPProtocol
    private var dataAutocomplete: DataAutocompleteProtocol
    
    private var allStations: [String : String] = [:]
    private var allTrainRoutes: [TrainRoute] = []
    
    //Input
    @Published var city = ""
    
    //Output
//    @Published var myCity: Result<GeocodingCity, Error>?
    @Published var myCity1: Result<AutocompleteCityElemnt, Error>?
    @Published var autocompleteCities: Result<AutocompleteCities, Error>?
    @Published var mainCities: Result<AutocompleteCities, Error>?
    
    func getLocation(_ element: AutocompleteCityElemnt) -> Location {
        var location = Location()
        
        location.name = element.name
        location.countryName = element.countryName
        location.codeIATA = element.code
        
        location.trainStationId = allStations.compactMap{$0.value.lowercased().contains(element.name.lowercased()) ? $0.key : nil}
        
        location.routes = allTrainRoutes.filter{$0.departureStationName.contains(element.name) || $0.arrivalStationName.contains(element.name)}
        
       return location
    }
    
    func stationName(_ stationId: String) -> String  {
        let resultDict = allStations.first(where: {key, value in
            key == stationId
        })
        return resultDict?.value ?? "No Name"
    }
    
    init(
        trainStationsAndRoutes: TrainStationsAndRoutesProtocol = TrainStationsAndRoutes(inputFile: "tutu_routes.csv"),
        geocodingIP: GeocodingIPProtocol = GeocodingIP(),
        dataAutocomplete : DataAutocompleteProtocol = Autocomplete()
    ) {
        self.trainStationsAndRoutes = trainStationsAndRoutes
        self.geocodingIP = geocodingIP
        self.dataAutocomplete = dataAutocomplete
        
        allStations = trainStationsAndRoutes.getTrainStationsNames()
        allTrainRoutes = trainStationsAndRoutes.getTrainRoutes()
        
//        dataGeocodingIP.getCity()
//            .asResult()
//            .receive(on: DispatchQueue.main)
//            .assign(to: &$myCity)
        
        self.geocodingIP.getCity()
            .flatMap{self.dataAutocomplete.getAutocompleteCities(city: $0.name)}
            .filter{!$0.isEmpty}
            .map{$0.first!}
            .asResult()
            .receive(on: DispatchQueue.main)
            .assign(to: &$myCity1)
        
        Just("Россия")
            .flatMap{self.dataAutocomplete.getAutocompleteCities(city: $0).asResult()}
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$mainCities)
        
        $city
            .debounce(for: 0.6, scheduler: DispatchQueue.main)
            .filter{!$0.isEmpty}
            .flatMap{self.dataAutocomplete.getAutocompleteCities(city: $0).asResult()}
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$autocompleteCities)
    }
}

