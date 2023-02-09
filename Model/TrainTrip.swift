//
//  TrainTrip.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.02.2023.
//

import SwiftUI

// MARK: - Trip
struct TrainTrip: Codable, Comparable, Hashable {
    static func < (lhs: TrainTrip, rhs: TrainTrip) -> Bool {
        (lhs.categories.min().map {$0.price} ?? 0) < (rhs.categories.min().map {$0.price} ?? 0)
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
        case runArrivalStation, runDepartureStation, trainNumber, travelTimeInSeconds

        case categories
    }
}
// MARK: - Category
struct Category: Codable, Comparable, Hashable {
    static func < (lhs: Category, rhs: Category) -> Bool {
        lhs.price < rhs.price
    }

    let price: Int
    let type: TypeEnum
}
// MARK: - TypeEnum
enum TypeEnum: String, Codable {
    case coupe
    case lux
    case plazcard
    case sedentary
    case soft

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
