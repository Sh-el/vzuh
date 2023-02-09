//
//  GeocodingIP.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 12.01.2023.
//

import SwiftUI
import Combine

protocol GeocodingIpProtocol {
    func getCity() -> AnyPublisher<GeocodingCity, Error>
}

struct GeocodingIP: GeocodingIpProtocol {
    private let apiService: APIServiceProtocol

    private func getIP() -> AnyPublisher<IpForCity, Error> {
        Just(EndpointIP.ipForPlace)
            .tryMap {
                guard let url = $0.absoluteURL else {
                    throw RequestError.addressUnreachable
                }
                return url
            }
            .flatMap(apiService.fetch)
            .eraseToAnyPublisher()
    }

    func getCity() -> AnyPublisher<GeocodingCity, Error> {
        getIP()
            .tryMap {
                guard let url = EndpointCity.city($0.ip).absoluteURL else {
                    throw RequestError.addressUnreachable
                }
                return url
            }
            .flatMap(apiService.fetch)
            .eraseToAnyPublisher()
    }

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
}

extension GeocodingIP {
    enum EndpointIP {
        case ipForPlace

        var baseURL: URL? {
            if let baseURL = URL(string: "https://api.ipify.org/") {
                return baseURL
            }
            return  nil
        }

        var path: String {
            switch self {
            case .ipForPlace:
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
            case .ipForPlace:
                urlComponents.queryItems = [URLQueryItem(name: "format", value: "json")]
            }
            return urlComponents.url
        }
    }
}

extension GeocodingIP {
    enum EndpointCity {
        case city(String)

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

