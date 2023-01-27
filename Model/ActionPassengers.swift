//
//  ActionPassengers.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 26.01.2023.
//

import SwiftUI
import Combine

protocol ActionPassengersProtocol {
    func action(_ passengers: ([Passenger], ActionPassenger?)) -> AnyPublisher<(ActionPassengersResult, [Passenger]?), Never>
}

struct ActionPassengers: ActionPassengersProtocol {
    func action(_ passengers: ([Passenger], ActionPassenger?)) -> AnyPublisher<(ActionPassengersResult, [Passenger]?), Never> {
       Just(passengers)
            .filter{$0.1 != nil}
            .map{
                switch $0.1! {
                case .addAdult:
                    guard $0.0.count + 1 <= Const.maxNumberPassengers else  {
                        return (.lotsPassengers, nil)
                    }
                    var arr = $0.0
                    arr.append(.adult)
                    return (.ok, arr)
                    
                case .removeAdult:
                    guard $0.0.filter({$0 == .adult}).count - 1 >= 1 else  {
                        return (.fewPassengers, nil)
                    }
                    guard $0.0.filter({$0 == .adult}).count - 1 >= $0.0.filter({$0 == .baby}).count else  {
                        return (.fewerAdultsThansBabies, nil)
                    }
                    var arr = $0.0
                    if let index = arr.firstIndex(of: .adult) {
                        arr.remove(at: index)
                    }
                    return (.ok, arr)
                    
                case .addChild:
                    var arr = $0.0
                    arr.append(.child)
                    return (.ok, arr)
                    
                case .removeChild:
                    var arr = $0.0
                    if let index = arr.firstIndex(of: .child) {
                        arr.remove(at: index)
                    }
                    return (.ok, arr)
                    
                case .addBaby:
                    guard $0.0.filter({$0 == .baby}).count + 1 <= $0.0.filter({$0 == .adult}).count else  {
                        return (.lotsBabies, nil)
                    }
                    var arr = $0.0
                    arr.append(.baby)
                    return (.ok, arr)
                    
                case .removeBaby:
                    var arr = $0.0
                    if let index = arr.firstIndex(of: .baby) {
                        arr.remove(at: index)
                    }
                    return (.ok, arr)
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

enum ActionPassenger {
    case addAdult
    case removeAdult
    case addChild
    case removeChild
    case addBaby
    case removeBaby
}

enum ActionPassengersResult: String {
    case lotsPassengers = "Можно выбрать не больше, чем четыре пассажира!"
    case fewPassengers = "Можно выбрать не менее одного взрослого пассажира!"
    case fewerAdultsThansBabies = "Взрослых не может быть меньше, чем детей младше двух лет!"
    case lotsBabies = "Детей до двух лет должно быть не больше, чем взрослых!"
    case ok
}

//struct Child: Hashable, Identifiable {
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
//}
