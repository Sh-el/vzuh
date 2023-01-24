//
//  Model.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 02.01.2023.
//

import SwiftUI
import Combine

final class MainModel: ObservableObject {
    @Published var mainMenuTabSelected: MainMenuTab = .all
    @Published var isSearch = false
    
    @Published var departure: Location?
    @Published var arrival: Location?
    
    @Published var dateDeparture = Date.now
    @Published var dateBack = Date.now
    @Published var isDateBack = false
    
    @Published var adultPassengers: Int = 1
    @Published var children: [Child] = []
    @Published var resultAddPassengers = ResultAddPassengers(error: .everythingOk, isMaxPassengers: false)
    
    //Train
    typealias TrainScheduleResultArray = Result<[TrainSchedule.Trip], Error>
    
    private var trainAPI: TrainAPIProtocol
    private var dataTrainSchedule: TrainScheduleProtocol
    private var trainStationsAndRoutes: TrainStationsAndRoutesProtocol
    
    @Published var trainScheduleForSort: [TrainSchedule.Trip] = []
    @Published var sortTrain: TrainSchedule.Sort?
    
    @Published var trainSchedule: TrainScheduleResultArray?
  
    func trainMinPrice(schedule: [TrainSchedule.Trip]) -> TrainSchedule.Trip? {
        dataTrainSchedule.minPrice(schedule)
    }
    
    func getTrips(_ value: (Location?, Location?)) ->  AnyPublisher<[TrainSchedule.Trip], Error>{
        Just(value)
            .flatMap{self.trainStationsAndRoutes.validTrainRoutes($0.0!, $0.1!)}
            .flatMap{self.trainAPI.getTrainSchedule($0)}
            .eraseToAnyPublisher()
    }
    
    
    func changeCity() {
        (arrival, departure) = (departure, arrival)
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
    
    func numberPassengers() -> Int {
        let numberAdult = adultPassengers
        let numberChildren = children.count
        return numberAdult + numberChildren
    }
    
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
    
    func convertSecondsToHrMinute(seconds: String) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru")
        formatter.calendar = calendar
        
        if let seconds = Int(seconds) {
            let formattedString = formatter.string(from:TimeInterval(seconds))!
            return formattedString
        } else {
            return ""
        }
    }
    
    init(
        dataTrain: TrainAPIProtocol = TrainApi(),
        dataTrainSchedule: TrainScheduleProtocol = TrainSchedule(),
        trainStationsAndRoutes: TrainStationsAndRoutesProtocol = TrainStationsAndRoutes(inputFile: "tutu_routes.csv")
    ) {
        self.trainAPI = dataTrain
        self.dataTrainSchedule = dataTrainSchedule
        self.trainStationsAndRoutes = trainStationsAndRoutes
        imagesBackground = Const.imagesBackground
        buttonsMain = Const.buttonsMain
       
        Publishers.CombineLatest4($departure, $arrival, $mainMenuTabSelected, $isSearch)
            .filter{$0.3}
            .filter{$0.2 == .all}
            .filter{$0.0 != nil && $0.1 != nil}
            .filter{!($0.0?.name.isEmpty)! && !($0.1?.name.isEmpty)!}
            .map{($0.0, $0.1)}
            .flatMap{self.getTrips($0).asResult()}
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$trainSchedule)
        
        Publishers.CombineLatest($trainScheduleForSort, $sortTrain)
            .filter{!$0.0.isEmpty}
            .filter{$0.1 != nil}
            .tryMap{(trips, sort) -> [TrainSchedule.Trip] in
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
            .asResult()
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$trainSchedule)
    }
    
    @Published var backgroundMain = "day_snow"
    @Published var imagesBackground: [String] = []
    @Published var buttonsMain: [MainMenuTab] = []
    
    private struct Const {
        static let maxNumberPassengers = 4
        
        static let imagesBackground = ["day_snow",
                                       "snow_mountain",
                                       "day_clearsky",
                                       "day_cloudy",
                                       "night_clearsky",
                                       "tokyo-station"]
        
        static let buttonsMain = [MainMenuTab.all,
                                  MainMenuTab.flights,
                                  MainMenuTab.train,
                                  MainMenuTab.bus]
    }
    
    func sortTrainSchedule(by sort: TrainSchedule.Sort) {
        guard let arr = trainSchedule else {return}
        
        Publishers.CombineLatest(Just(arr), Just(sort))
            .tryMap{(tripsResult, sort) in
                switch tripsResult {
                case .success(let trips):
                    return (trips, sort)
                case .failure(let error):
                    throw error
                }
            }
            .map{(trips, sort) in
                switch sort {
                case .earliest:
                    return trips.sorted(by: {$0.departureTime < $1.departureTime})
                case .lowestPrice:
                    return trips.sorted(by: {$0.categories.min().map{$0.price} ?? 0 < $1.categories.min().map{$0.price} ?? 0})
                case .fastest:
                    return trips.sorted(by: {$0.travelTimeInSeconds < $1.travelTimeInSeconds})
                case .latest:
                    return trips.sorted(by: {$0.departureTime > $1.departureTime})
                }
            }
            .asResult()
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$trainSchedule)
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

enum MainMenuTab {
    case all
    case hotels
    case flights
    case train
    case bus
    
    var imageName: String {
        switch self {
        case .all:
            return "globe"
        case .hotels:
            return "bed.double"
        case .flights:
            return "airplane"
        case .train:
            return "tram"
        case .bus:
            return "bus"
        }
    }
}


