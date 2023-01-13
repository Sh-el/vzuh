//
//  MainCities.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 12.01.2023.
//

import SwiftUI

struct MainCity: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let hotels: Bool
    let trainStations: Bool
    let airports: Bool
    let busStations: Bool
}

protocol DataMainCitiesProtocol {
    func getMainCities() -> [MainCity]
}

struct DataMainCities: DataMainCitiesProtocol {
    
    let cities: [MainCity]
    
    func getMainCities() -> [MainCity] {
        cities
    }
}

