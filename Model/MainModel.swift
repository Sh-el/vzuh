//
//  Model.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 02.01.2023.
//

import SwiftUI
import Combine

class MainModel: ObservableObject {
    typealias TrainScheduleResultArray = Result<[TrainSchedule], Error>
    
    private var dataTrain: DataTrainProtocol
    
    @Published var backgroundMain = "day_snow"
    @Published var imagesBackground: [String] = []
    @Published var buttonsMain: [ButtonsMain] = []
    
    @Published var departure: Location?
    @Published var arrival: Location?
    
    @Published var dateDeparture = Date.now
    @Published var dateBack: Date = Date.now
    
    @Published var adultPassengers: Int = 1
    @Published var children: [Child] = []
    @Published var resultAddPassengers = ResultAddPassengers(error: .everythingOk, isMaxPassengers: false)
    
    @Published var trainSchedule: TrainScheduleResultArray?
    
    
    func numberPassengers() -> Int {
        let numberAdult = adultPassengers
        let numberChildren = children.count
        return numberAdult + numberChildren
    }
    
    private var isPssengersCountValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($adultPassengers, $children)
            .map{$0 + $1.count < Const.maxNumberPassengers}
            .eraseToAnyPublisher()
    }
    
    private var isMaxPassengers: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($adultPassengers, $children)
            .map{$0 + $1.count + 1 == Const.maxNumberPassengers}
            .eraseToAnyPublisher()
    }
    
    private var isFewPassengers: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($adultPassengers, $children)
            .map{$0 + $1.filter{$0.age == .zero || $0.age == .one}.count <= 1}
            .eraseToAnyPublisher()
    }
    
    //    func addAdult1() {
    //        Publishers.CombineLatest($adultPassengers, $children)
    //            .map{$0 + $1.count > Const.maxNumberPassengers ? ResultAddPassengers(error: .lotsPassengers, isMaxPassengers: true) : }
    //
    //
    //
    //        guard numberChildren + adultPassengers < Const.maxNumberPassengers else {
    //            resultAddPassengers = ResultAddPassengers(error: .lotsPassengers, isMaxPassengers: true)
    //            return
    //        }
    //
    //        numberAdult = numberAdult + 1
    //        adultPassengers = numberAdult
    //        if numberChildren + numberAdult == Const.maxNumberPassengers {
    //            resultAddPassengers = ResultAddPassengers(error: .everythingOk, isMaxPassengers: true)
    //        } else {
    //            resultAddPassengers = ResultAddPassengers(error: .everythingOk, isMaxPassengers: false)
    //        }
    //    }
    
    func addAdult() {
        var numberAdult = adultPassengers
        let numberChildren = children.count
        guard numberChildren + adultPassengers < Const.maxNumberPassengers else {
            resultAddPassengers = ResultAddPassengers(error: .lotsPassengers, isMaxPassengers: true)
            return
        }
        
        numberAdult = numberAdult + 1
        adultPassengers = numberAdult
        if numberChildren + numberAdult == Const.maxNumberPassengers {
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
    
    private func validTrainRoutes(_ departure: Location, _ arrival: Location) -> AnyPublisher<[Route], Never> {
        Publishers.Zip(Just(departure), Just(arrival))
            .map{(Set($0.0.routes), Set($0.1.routes))}
            .map{Array($0.0.intersection($0.1)).filter{$0.departureStationName.contains(departure.name)}}
            .eraseToAnyPublisher()
    }
    
    func getTrainSchedule() {
        Publishers.Zip($departure, $arrival)
            .filter{$0.0 != nil && $0.1 != nil}
            .filter{!($0.0?.name.isEmpty)! && !($0.1?.name.isEmpty)!}
            .flatMap{self.validTrainRoutes($0.0!, $0.1!)}
            .flatMap{self.dataTrain.fetchTrainSchedule($0)}
            .filter{!$0.url.isEmpty}
            .scan([], {$0 + [$1]})
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
                                       "night_clearsky",
                                       "tokyo-station"]
        
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


struct ResultAddPassengers {
    enum Error: String {
        case fewAdults = "Взрослых не может быть меньше, чем детей младше двух лет!"
        case lotsPassengers = "Можно выбрать не больше, чем четыре пассажира!"
        case fewPassengers = "Можно выбрать не менее одного взрослого пассажира!"
        case lotsBabies = "Детей до двух лет должно быть не больше, чем взрослых!"
        case everythingOk
    }
    
    var error: Error
    let isMaxPassengers: Bool
}

enum ButtonsMain {
    case all
    case hotels
    case airplane
    case train
    case bus
    
    var imageName: String {
        switch self {
        case .all:
            return "globe"
        case .hotels:
            return "bed.double"
        case .airplane:
            return "airplane"
        case .train:
            return "tram"
        case .bus:
            return "bus"
        }
    }
}
