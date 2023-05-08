//
//  ActionPassengers.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 26.01.2023.
//

import SwiftUI
import Combine

protocol PassengersManagerProtocol {
    func changeNumberPassengers(_ passengers: ([Passenger], ActionNumberPassengers?))
    -> AnyPublisher<(ChangeNumberPassengersError, [Passenger]?), Never>
}

struct PassengersManager: PassengersManagerProtocol {
    private let maxNumberPassengers = 4
    
    private func addAdult(_ passengers: [Passenger]) -> (ChangeNumberPassengersError, [Passenger]?) {
        if passengers.count + 1 > maxNumberPassengers {
            return (.lotsPassengers, nil)
        }
        
        var newPassengers = passengers
        newPassengers.append(.adult)
        return (.valid, newPassengers)
    }

    private func removeAdult(_ passengers: [Passenger]) -> (ChangeNumberPassengersError, [Passenger]?) {
        guard passengers.filter({$0 == .adult}).count - 1 >= 1 else {
            return (.fewPassengers, nil)
        }
        guard passengers.filter({$0 == .adult}).count - 1 >= passengers.filter({$0 == .baby}).count else {
            return (.fewerAdultsThanBabies, nil)
        }
        var arr = passengers
        if let index = arr.firstIndex(of: .adult) {
            arr.remove(at: index)
        }
        return (.valid, arr)
    }

    private func addChild(_ passengers: [Passenger]) -> (ChangeNumberPassengersError, [Passenger]?) {
        var arr = passengers
        arr.append(.child)
        return (.valid, arr)
    }

    private func removeChild(_ passengers: [Passenger]) -> (ChangeNumberPassengersError, [Passenger]?) {
        var arr = passengers
        if let index = arr.firstIndex(of: .child) {
            arr.remove(at: index)
        }
        return (.valid, arr)
    }

    private func addBaby(_ passengers: [Passenger]) -> (ChangeNumberPassengersError, [Passenger]?) {
        guard passengers.filter({$0 == .baby}).count + 1 <= passengers.filter({$0 == .adult}).count else {
            return (.lotsBabies, nil)
        }
        var arr = passengers
        arr.append(.baby)
        return (.valid, arr)
    }

    private func removeBaby(_ passengers: [Passenger]) -> (ChangeNumberPassengersError, [Passenger]?) {
        var arr = passengers
        if let index = arr.firstIndex(of: .baby) {
            arr.remove(at: index)
        }
        return (.valid, arr)
    }
    
//    private func add(passenger: Passenger, to passengers: [Passenger]) -> (ChangeNumberPassengersError, [Passenger]?) {
//            if passengers.count + 1 > maxNumberPassengers {
//                return (.lotsPassengers, nil)
//            }
//            var newPassengers = passengers
//            newPassengers.append(passenger)
//            return (.valid, passengers)
//        }
//
//        private func remove(passenger: Passenger, from passengers: [Passenger]) -> Result<[Passenger], ChangeNumberPassengersError> {
//            guard let index = passengers.firstIndex(of: passenger) else {
//                return .failure(.fewPassengers)
//            }
//            var newPassengers = passengers
//            newPassengers.remove(at: index)
//            return .success(newPassengers)
//        }

    func changeNumberPassengers(_ passengers: ([Passenger], ActionNumberPassengers?))
    -> AnyPublisher<(ChangeNumberPassengersError, [Passenger]?), Never> {
        Just(passengers)
            .filter {$0.1 != nil}
            .map {
                switch $0.1! {
                case .addAdult:
                    return addAdult($0.0)

                case .removeAdult:
                    return removeAdult($0.0)

                case .addChild:
                    return addChild($0.0)

                case .removeChild:
                    return removeChild($0.0)

                case .addBaby:
                    return addBaby($0.0)

                case .removeBaby:
                    return removeBaby($0.0)
                }
            }
            .eraseToAnyPublisher()
    }
    
}

enum Passenger: Hashable, CaseIterable, Identifiable {
    case adult
    case child
    case baby

    var id: Self {self}

    var description: String {
        switch self {
        case .adult:
            return "12 - 120 лет"
        case .child:
            return "2 - 11 лет"
        case .baby:
            return "0 - 1 год"
        }
    }
}

enum ActionNumberPassengers {
    case addAdult
    case removeAdult
    case addChild
    case removeChild
    case addBaby
    case removeBaby
}

enum ChangeNumberPassengersError: String {
    case lotsPassengers = "Можно выбрать не больше, чем четыре пассажира!"
    case fewPassengers = "Можно выбрать не менее одного взрослого пассажира!"
    case fewerAdultsThanBabies = "Взрослых не может быть меньше, чем детей младше двух лет!"
    case lotsBabies = "Детей до двух лет должно быть не больше, чем взрослых!"
    case valid
}
