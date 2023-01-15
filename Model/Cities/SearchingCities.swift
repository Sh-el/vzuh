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
    var routes: [Route] = []
}

final class SearchingCities: ObservableObject {
    private var dataTrain: DataTrainStationsProtocol
    private var dataGeocodingIP: DataGeocodingIPProtocol
    private var dataAutocomplete: DataAutocompleteProtocol
    
    private var allStations: [String : String] = [:]
    private var allTrainRoutes: [Route] = []
    
    //Input
    @Published var city = ""
    
    //Output
    @Published var myCity: Result<GeocodingCity, Error>?
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
    
    private func getAutocompleteCity(city: String) -> AnyPublisher<AutocompleteCities, Error> {
        dataAutocomplete.getAutocompleteCity(city: city)
    }
    
    private func getDataTrainStationsName() -> [String : String] {
        dataTrain.getTrainStationsName()
    }
    
    private func getTrainRoutes() -> [Route] {
        dataTrain.getTrainRoutes()
    }
   
    private var getCityForIP: AnyPublisher<Result<GeocodingCity, Error>?, Never> {
        dataGeocodingIP.getCity()
            .asResult()
    }
    
    func stationName(_ stationId: String) -> String  {
        let allStaions = allStations
        let resultDict = allStaions.first(where: {key, value in
            value == stationId
        })
        return resultDict?.key ?? "No Name"
    }
    
    init(
        dataTrain: DataTrainStationsProtocol = TrainStation(inputFile: "tutu_routes.csv"),
        dataGeocodingIP: DataGeocodingIPProtocol = GeocodingIP(),
        dataAutocomplete : DataAutocompleteProtocol = Autocomplete()
    ) {
        self.dataTrain = dataTrain
        self.dataGeocodingIP = dataGeocodingIP
        self.dataAutocomplete = dataAutocomplete
        
        allStations = getDataTrainStationsName()
        allTrainRoutes = getTrainRoutes()
        
        getCityForIP
            .receive(on: DispatchQueue.main)
            .assign(to: &$myCity)
        
        Just("Россия")
            .flatMap{self.getAutocompleteCity(city: $0).asResult()}
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$mainCities)
        
        $city
            .debounce(for: 1.9, scheduler: DispatchQueue.main)
            .filter{!$0.isEmpty}
            .flatMap{self.getAutocompleteCity(city: $0).asResult()}
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$autocompleteCities)
    }
}

