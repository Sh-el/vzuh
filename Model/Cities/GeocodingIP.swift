//
//  GeocodingIP.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 12.01.2023.
//

import SwiftUI
import Combine

protocol GeocodingIPProtocol {
    func getCity() -> AnyPublisher<GeocodingCity, Error>
}

struct GeocodingIP: GeocodingIPProtocol {
    private let apiService: APIServiceProtocol
    
    private func getIP() -> AnyPublisher<IP, Error> {
        Just(())
            .tryMap{
                guard let url = EndpointIP.ip.absoluteURL else {
                    throw RequestError.addressUnreachable
                }
                return url
            }
            .flatMap(apiService.get)
            .eraseToAnyPublisher()
    }
    
    func getCity() -> AnyPublisher<GeocodingCity, Error> {
        getIP()
            .tryMap{
                guard let url = EndpointCity.city(ip: $0.ip).absoluteURL else {
                    throw RequestError.addressUnreachable
                }
                return url
            }
            .flatMap(apiService.get)
            .eraseToAnyPublisher()
    }
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
}

extension GeocodingIP {
    enum EndpointIP {
        case ip
        
        var baseURL: URL? {
            if let baseURL = URL(string: "https://api.ipify.org/") {
                return baseURL
            }
            return  nil
        }
        
        var path: String {
            switch self {
            case .ip:
                return ""
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
            case .ip:
                urlComponents.queryItems = [URLQueryItem(name: "format", value: "json")]
            }
            return urlComponents.url
        }
    }
}

extension GeocodingIP {
    enum EndpointCity {
        case city(ip: String)
        
        var baseURL: URL? {
            if let baseURL = URL(string: "https://www.travelpayouts.com/") {
                return baseURL
            }
            return  nil
        }
        
        var path: String {
            switch self {
            case .city:
                return "whereami"
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
            case .city(let ip):
                urlComponents.queryItems = [
                    URLQueryItem(name: "locale", value: "ru"),
                    URLQueryItem(name: "ip", value: ip)
                ]
            }
            return urlComponents.url
        }
    }
}

struct GeocodingCity: Codable {
    let iata, name, countryName, coordinates: String
    
    enum CodingKeys: String, CodingKey {
        case iata, name
        case countryName = "country_name"
        case coordinates
    }
}

struct IP: Codable {
    let ip: String
}
