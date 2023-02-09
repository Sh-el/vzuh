//
//  GeocodingCity.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.02.2023.
//

import SwiftUI

struct GeocodingCity: Codable {
    let iata, name, countryName, coordinates: String

    enum CodingKeys: String, CodingKey {
        case iata, name
        case countryName = "country_name"
        case coordinates
    }
}

struct IpForCity: Codable {
    let ip: String
}
