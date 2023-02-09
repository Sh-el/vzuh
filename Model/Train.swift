//
//  TrainSchedule.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 16.01.2023.
//

import SwiftUI
import Combine

protocol TrainProtocol {
    func minPrice(in schedule: [TrainTrip]) -> TrainTrip?
    func sort(_ schedule: ([TrainTrip], Train.Sort?)) -> AnyPublisher<[TrainTrip], Error>
}

struct Train: Codable, TrainProtocol {
    var trips: [TrainTrip] = []
    var url: String = ""

    func minPrice(in schedule: [TrainTrip]) -> TrainTrip? {
    return schedule.filter { !$0.trainNumber.isEmpty }.min()
    }

    func sort(_ schedule: ([TrainTrip], Sort?)) -> AnyPublisher<[TrainTrip], Error> {
        Just(schedule)
            .tryMap {(trips, sort) in
                switch sort {
                case .earliest:
                    return trips.sorted(by: {$0.departureTime < $1.departureTime})
                case .lowestPrice:
                    return trips
                        .sorted(by: {$0.categories.min().map {$0.price} ?? 0 <
                            $1.categories.min().map {$0.price} ?? 0})
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
