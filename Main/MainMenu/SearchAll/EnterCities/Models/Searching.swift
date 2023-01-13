//
//  Geocoding.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.01.2023.
//

import SwiftUI
import Combine

final class Searching: ObservableObject {
    private var dataTrain: DataTrainStationsProtocol
    private var dataMainCities: DataMainCitiesProtocol
    private var dataGeocodingIP: DataGeocodingIPProtocol
    private var dataAutocomplete: DataAutocompleteProtocol
    
    @Published private var allStations: [String : String] = [:]
    
    //Input
    @Published var city = ""
    
    //Output
    @Published var stations: [String : String] = [:]
    @Published var mainCities: [MainCity] = []
    @Published var geocodingCity: Result<GeocodingCity, Error>?
    @Published var autocompleteCity: Result<AutocompleteCity, Error>?
    
    private func getDataTrainStationsName() -> [String : String] {
        dataTrain.getTrainStationsName()
    }
    
    func getMainCities() -> [MainCity] {
        dataMainCities.getMainCities()
    }
    
    func getCity() {
        dataGeocodingIP.getCity()
            .asResult()
            .receive(on: DispatchQueue.main)
            .assign(to: &$geocodingCity)
    }
    
    func stationName(_ stationId: String) -> String  {
        let allStaions = allStations
        let resultDict = allStaions.first(where: {key, value in
            value == stationId
        })
        return resultDict?.key ?? "No Name"
    }
    
    init(
        dataTrain: DataTrainStationsProtocol = TrainRoutes(inputFile: "tutu_routes.csv"),
        dataMainCities: DataMainCitiesProtocol = DataMainCities(cities: cities),
        dataGeocodingIP: DataGeocodingIPProtocol = GeocodingIP(),
        dataAutocomplete : DataAutocompleteProtocol = Autocomplete()
    ) {
        self.dataTrain = dataTrain
        self.dataMainCities = dataMainCities
        self.dataGeocodingIP = dataGeocodingIP
        self.dataAutocomplete = dataAutocomplete
        
        allStations = getDataTrainStationsName()
        mainCities = getMainCities()
        
        getCity()
        
        $city
            .debounce(for: 1.9, scheduler: DispatchQueue.main)
            .filter{!$0.isEmpty}
            .flatMap{dataAutocomplete.getAutocompleteCity(city: $0).asResult()}
            .print("auto")
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$autocompleteCity)
        
        
        Publishers.CombineLatest($allStations, $city)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map{allStations, city in
                allStations.filter{$0.key.lowercased().contains(city.lowercased())}
            }
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$stations)
    }
    
    private static let cities: [MainCity] = [
        MainCity(name: "Moscow",
                 description: "Capital",
                 hotels: true,
                 trainStations: true,
                 airports: true,
                 busStations: true),
        MainCity(name: "Magadan",
                 description: "FarEast",
                 hotels: true,
                 trainStations: true,
                 airports: true,
                 busStations: true)
    ]
}

