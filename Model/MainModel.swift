//
//  Model.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 02.01.2023.
//

import SwiftUI
import Combine

class MainModel: ObservableObject {
    typealias TrainScheduleResult = Result<TrainSchedule, Error>
    
    private var dataTrain: DataTrainProtocol
    
    @Published var backgroundMain = "day_snow"
    @Published var imagesBackground: [String] = []
    @Published var buttonsMain: [ButtonsMain] = []
  
    //Input
    @Published var departure = Station()
    @Published var arrival = Station()
    
    @Published var dateThere = Date.now
    @Published var dateBack: Date = Date.now
    
    @Published var adultPassengers: Int = 1
    @Published var children: [Child] = []
    @Published var resultAddPassengers = ResultAddPassengers(error: .everythingOk, isMaxPassengers: false)
    
    //Output
    @Published var trainSchedule: TrainScheduleResult?
    
    func addAdult() {
        var numberAdult = adultPassengers
        let arr = children
        let numberChildren = arr.count
        guard numberChildren + adultPassengers < Const.maxNumberPassengers else {
            resultAddPassengers = ResultAddPassengers(error: .lotsPassengers, isMaxPassengers: true)
            return
        }
        
        numberAdult = numberAdult + 1
        adultPassengers = numberAdult
        if arr.count + numberAdult == Const.maxNumberPassengers {
            resultAddPassengers = ResultAddPassengers(error: .everythingOk, isMaxPassengers: true)
        } else {
            resultAddPassengers = ResultAddPassengers(error: .everythingOk, isMaxPassengers: false)
        }
    }
    
    func removeAdult() {
        let numberAdult = adultPassengers
        let arr = children
        let numberBabies = arr.filter{$0.age == .zero}.count + arr.filter{$0.age == .one}.count
        guard numberAdult + numberBabies > 1 else {
            resultAddPassengers = ResultAddPassengers(error: .fewPassengers, isMaxPassengers: false)
            return
        }
        if numberAdult > numberBabies  {
            adultPassengers = numberAdult - 1
            resultAddPassengers = ResultAddPassengers(error: .everythingOk, isMaxPassengers: false)
        } else if numberAdult + numberBabies == Const.maxNumberPassengers {
            resultAddPassengers = ResultAddPassengers(error: .fewAdults, isMaxPassengers: true)
        } else {
            resultAddPassengers = ResultAddPassengers(error: .fewAdults, isMaxPassengers: false)
        }
    }
    
    func addChild(_ child: Child)  {
        func areFewerKidsThanAdults(_ child: Child) -> Bool {
            guard child.age == .zero || child.age == .one else {return true}
            let arr = children
            let numberBabies = arr.filter{$0.age == .zero}.count + arr.filter{$0.age == .one}.count
            if numberBabies  < adultPassengers {
                return true
            } else {
                return false
            }
        }
        
        var arr = children
        let numberChildren = arr.count
        guard numberChildren + adultPassengers < Const.maxNumberPassengers else {
            resultAddPassengers = ResultAddPassengers(error: .lotsPassengers, isMaxPassengers: true)
            return
        }
        guard areFewerKidsThanAdults(child) else {
            resultAddPassengers = ResultAddPassengers(error: .lotsBabies, isMaxPassengers: false)
            return
        }
        arr.append(child)
        children = arr
        if arr.count + adultPassengers == Const.maxNumberPassengers {
            resultAddPassengers = ResultAddPassengers(error: .everythingOk, isMaxPassengers: true)
        } else {
            resultAddPassengers = ResultAddPassengers(error: .everythingOk, isMaxPassengers: false)
        }
    }
    
    func removeChild(_ child: Child) {
        var arr = children
        if let index = arr.firstIndex(of: child) {
            arr.remove(at: index)
            children = arr
            resultAddPassengers = ResultAddPassengers(error: .everythingOk, isMaxPassengers: false)
        }
    }
    
    func getTrainSchedule() {
        Publishers.Zip($departure, $arrival)
            .filter{!$0.0.stationId.isEmpty && !$0.1.stationId.isEmpty}
            .flatMap{self.dataTrain.fetchTrainSchedule(from: $0.0.stationId, to: $0.1.stationId)}
            .asResult()
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$trainSchedule)
        
    }
  
    init(dataTrain: DataTrainProtocol = TrainApi()) {
        self.dataTrain = dataTrain
        imagesBackground = Const.imagesBackground
        buttonsMain = Const.buttonsMain
 
    }
    
    private struct Const {
        static let maxNumberPassengers = 4
        static let imagesBackground = ["day_snow",
                                       "snow_mountain",
                                       "day_clearsky",
                                       "day_cloudy",
                                       "night_clearsky"]
        static let buttonsMain = [ButtonsMain.all,
                                  ButtonsMain.hotels,
                                  ButtonsMain.airplane,
                                  ButtonsMain.train,
                                  ButtonsMain.bus]
    }
}

extension Publisher {
    func asResult() -> AnyPublisher<Result<Output, Failure>?, Never> {
        self
            .map(Result.success)
            .catch{error in
                Just(.failure(error))
            }
            .eraseToAnyPublisher()
    }
}


struct Child: Hashable, Identifiable {
    var id = UUID()
    
    enum AgeChild: String, CaseIterable, Identifiable {
        case zero = "меньше года"
        case one = "1 год"
        case two = "2 года"
        case three = "3 года"
        case four = "4 года"
        case five = "5 лет"
        case six = "6 лет"
        case seven = "7 лет"
        case eight = "8 лет"
        case nine =  "9 лет"
        case ten = "10 лет"
        case eleven = "11 лет"
        
        var id: Self {self}
        
        var description: String {
            switch self {
            case .zero:
                return "меньше года"
            case .one:
                return "1 год"
            case .two:
                return "2 года"
            case .three:
                return "3 года"
            case .four:
                return "4 года"
            case .five:
                return "5 лет"
            case .six:
                return "6 лет"
            case .seven:
                return "7 лет"
            case .eight:
                return "8 лет"
            case .nine:
                return "9 лет"
            case .ten:
                return "10 лет"
            case .eleven:
                return "11 лет"
            }
        }
    }
    
    var age: AgeChild
}
