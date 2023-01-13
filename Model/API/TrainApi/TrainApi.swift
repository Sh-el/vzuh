//
//  TrainApi.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.01.2023.
//

import SwiftUI
import Combine

struct TrainSchedule: Codable {
    let trips: [Trip]
    let url: String
}
// MARK: - Trip
extension TrainSchedule {
    struct Trip: Codable, Identifiable {
        let id = UUID()
        
        let arrivalStation, arrivalTime: String
        let categories: [Category]
        let departureStation, departureTime: String
        let firm: Bool
        let name: String?
        let numberForURL, runArrivalStation, runDepartureStation, trainNumber: String
        let travelTimeInSeconds: String
        
        enum CodingKeys: String, CodingKey {
            case arrivalStation, arrivalTime, categories, departureStation, departureTime, firm, name
            case numberForURL = "numberForUrl"
            case runArrivalStation, runDepartureStation, trainNumber, travelTimeInSeconds
        }
    }
}
// MARK: - Category
extension TrainSchedule {
    struct Category: Codable {
        let price: Int
        let type: TypeEnum
    }
    
    enum TypeEnum: String, Codable {
        case coupe = "coupe"
        case lux = "lux"
        case plazcard = "plazcard"
        case soft = "soft"
    }
}

protocol DataTrainProtocol {
    func fetchTrainSchedule(from: String, to: String) -> AnyPublisher<TrainSchedule, Error>
}

struct TrainApi: DataTrainProtocol {
    private let apiService: APIServiceProtocol
    
    func fetchTrainSchedule(from: String, to: String) -> AnyPublisher<TrainSchedule, Error> {
        guard let url = EndpointTrain.search(term: from, term2: to).absoluteURL else {
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

extension TrainApi {
    enum EndpointTrain {
        case search(term: String, term2: String)
        case order
        
        var baseURL: URL? {
            if let baseURL = URL(string: "https://suggest.travelpayouts.com/") {
                return baseURL
            }
            return  nil
        }
        
        var path: String {
            switch self {
            case .search:
                return "search"
            case .order:
                return "order"
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
            case .search (let term, let term2):
                urlComponents.queryItems = [
                    URLQueryItem(name: "service", value: "tutu_trains"),
                    URLQueryItem(name: "term", value: term),
                    URLQueryItem(name: "term2", value: term2)
                ]
            default:
                urlComponents.queryItems = [
                    URLQueryItem(name: "", value: "")
                ]
            }
            return urlComponents.url
        }
    }
}
