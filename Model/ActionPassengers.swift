//
//  ActionPassengers.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 26.01.2023.
//

import SwiftUI
import Combine

protocol ActionPassengersProtocol {
    func changeNumberPassengers(_ passengers: ([Passenger], ActionNumberPassengers?))
    -> AnyPublisher<(ChangeNumberPassengersError, [Passenger]?), Never>
}

struct ActionPassengers: ActionPassengersProtocol {
    private func addAdult(_ passengers: [Passenger]) -> (ChangeNumberPassengersError, [Passenger]?) {
        guard passengers.count + 1 <= Const.maxNumberPassengers else {
            return (.lotsPassengers, nil)
        }
        var arr = passengers
        arr.append(.adult)
        return (.valid, arr)
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

    private struct Const {
        static let maxNumberPassengers = 4
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

// struct Child: Hashable, Identifiable {
//    var id = UUID()
//    
//    enum AgeChild: String, CaseIterable, Identifiable {
//        case zero = "меньше года"
//        case one = "1 год"
//        case two = "2 года"
//        case three = "3 года"
//        case four = "4 года"
//        case five = "5 лет"
//        case six = "6 лет"
//        case seven = "7 лет"
//        case eight = "8 лет"
//        case nine =  "9 лет"
//        case ten = "10 лет"
//        case eleven = "11 лет"
//        
//        var id: Self {self}
//    }
//    
//    var age: AgeChild
// }
