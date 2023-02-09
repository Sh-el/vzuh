//
//  AutocompleteCityElemnt.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.02.2023.
//

import SwiftUI

struct AutocompleteCityElemnt: Codable {
    let id: String
    let code, name, countryCode, countryName: String
    let stateCode: String?
    let coordinates: Coordinates
    let weight: Int
    let mainAirportName: String?

    enum CodingKeys: String, CodingKey {
        case id, code, name
        case countryCode = "country_code"
        case countryName = "country_name"
        case stateCode = "state_code"
        case coordinates
        case weight
        case mainAirportName = "main_airport_name"
    }

    struct Coordinates: Codable {
        let lon, lat: Double
    }
}
