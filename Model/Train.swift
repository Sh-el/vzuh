//
//  TrainSchedule.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 16.01.2023.
//

import SwiftUI
import Combine

protocol TrainProtocol {
    func minPrice(_ schedule: [Train.Trip]) -> Train.Trip?
    func sort(_ schedule: ([Train.Trip], Train.Sort?)) -> AnyPublisher<[Train.Trip], Error>
}

struct Train: Codable, TrainProtocol {
    var trips: [Trip] = []
    var url: String = ""
    
    func minPrice(_ schedule: [Train.Trip]) -> Trip? {
        var result: Trip?
        var subscriptions = Set<AnyCancellable>()
        schedule
            .publisher
            .filter{!$0.trainNumber.isEmpty}
            .min()
            .sink(receiveValue: {value in
                result = value
            })
            .store(in: &subscriptions)
        return result
    }
    
    func sort(_ schedule: ([Trip], Sort?)) -> AnyPublisher<[Trip], Error> {
        Just(schedule)
        .tryMap{(trips, sort) in
            switch sort {
            case .earliest:
                return trips.sorted(by: {$0.departureTime < $1.departureTime})
            case .lowestPrice:
                return trips.sorted(by: {$0.categories.min().map{$0.price} ?? 0 < $1.categories.min().map{$0.price} ?? 0})
            case .fastest:
                return trips.sorted(by: {$0.travelTimeInSeconds < $1.travelTimeInSeconds})
            case .latest:
                return trips.sorted(by: {$0.departureTime > $1.departureTime})
            case .none:
                return trips
            }
        }
        .eraseToAnyPublisher()
    }
    
}
// MARK: - Trip
extension Train {
    struct Trip: Codable, Comparable, Hashable {
        static func < (lhs: Trip, rhs: Trip) -> Bool {
            (lhs.categories.min().map{$0.price} ?? 0) < (rhs.categories.min().map{$0.price} ?? 0)
        }
   
        func hash(into hasher: inout Hasher) {
                hasher.combine(trainNumber)
            }
        
        let arrivalStation, arrivalTime: String
        
        let departureStation, departureTime: String
        let numberForURL, runArrivalStation, runDepartureStation, trainNumber: String
        let firm: Bool
        let name: String?
        let travelTimeInSeconds: String
        
        let categories: [Category]
        
        enum CodingKeys: String, CodingKey {
            case arrivalStation, arrivalTime, departureStation, departureTime, firm, name
            case numberForURL = "numberForUrl"
            case runArrivalStation, runDepartureStation, trainNumber , travelTimeInSeconds
            
            case categories
        }
    }
}
// MARK: - Category
extension Train {
    struct Category: Codable, Comparable, Hashable {
        static func < (lhs: Category, rhs: Category) -> Bool {
            lhs.price < rhs.price
        }
        
        let price: Int
        let type: TypeEnum
    }
    
    enum TypeEnum: String, Codable {
        case coupe = "coupe"
        case lux = "lux"
        case plazcard = "plazcard"
        case sedentary = "sedentary"
        case soft = "soft"
        
        var description: String {
            switch self {
            case .coupe:
                return "Купе"
            case .lux:
                return "Люкс"
            case .plazcard:
                return "Плацкарт"
            case .sedentary:
                return "Сидячий"
            case .soft:
                return "СВ"
            }
        }
    }
}
// MARK: - Sort
extension Train {
    enum Sort: Identifiable {
        case earliest
        case lowestPrice
        case fastest
        case latest
        
        var description: String {
            switch self {
            case .earliest:
                return "сначала ранние"
            case .lowestPrice:
                return "сначала дешевые"
            case .fastest:
                return "сначала быстрые"
            case .latest:
                return "сначала поздние"
            }
        }
        
        var id: Self {self}
    }
}
