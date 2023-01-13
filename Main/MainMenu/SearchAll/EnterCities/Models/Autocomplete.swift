//
//  Autocomplete.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 13.01.2023.
//

import SwiftUI
import Combine

typealias AutocompleteCity = [AutocompleteCityElemnt]

protocol DataAutocompleteProtocol {
    func getAutocompleteCity(city: String) -> AnyPublisher<AutocompleteCity, Error>
}

struct Autocomplete: DataAutocompleteProtocol {
    private let apiService: APIServiceProtocol
    
    func getAutocompleteCity(city: String) -> AnyPublisher<AutocompleteCity, Error> {
        guard let url = Endpoint.places(city: city).absoluteURL else {
            return  Fail(error: RequestError.addressUnreachable)
                .eraseToAnyPublisher()
        }
        return apiService.get(url: url)
            .eraseToAnyPublisher()
    }
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
}

extension Autocomplete {
    enum Endpoint {
        case places(city: String)
        
        var baseURL: URL? {
            if let baseURL = URL(string: "https://autocomplete.travelpayouts.com/") {
                return baseURL
            }
            return  nil
        }
        
        var path: String {
            switch self {
            case .places:
                return "places2"
            }
        }
        
        var absoluteURL: URL? {
            guard let baseURL = baseURL else {
                return nil
            }
            let queryURL = baseURL.appendingPathComponent(path)
            let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
            guard var urlComponents = components else {
                return nil
            }
            switch self {
            case .places(let city):
                urlComponents.queryItems = [
                    URLQueryItem(name: "locale", value: "ru"),
                    URLQueryItem(name: "types[]", value: "city"),
                    URLQueryItem(name: "term", value: city)
                ]
            }
            return urlComponents.url
        }
    }
}

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




