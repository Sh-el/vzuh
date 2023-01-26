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
    
    //Passengers
    private var actionPassengers: ActionPassengersProtocol
    @Published var passengers: [Passenger] = [.adult]
    @Published var inputPassengersForAction: ([Passenger], ActionPassenger?) = ([], nil)
    @Published var actionPassengersResult: ActionPassengersResult  = .ok
    
    //Train
    typealias TrainScheduleResultArray = Result<[TrainSchedule.Trip], Error>
    private var trainAPI: TrainAPIProtocol
    private var trainScheduleProtocol: TrainScheduleProtocol
    private var trainStationsAndRoutes: TrainStationsAndRoutesProtocol
    
    @Published var trainSchedule: TrainScheduleResultArray?
    @Published var inputTrainScheduleForSort: ([TrainSchedule.Trip], TrainSchedule.Sort?) = ([], nil)
    
    func trainMinPrice(schedule: [TrainSchedule.Trip]) -> TrainSchedule.Trip? {
        trainScheduleProtocol.minPrice(schedule)
    }
    
    private func getTrips(_ value: (Location?, Location?)) ->  AnyPublisher<[TrainSchedule.Trip], Error>{
        Just(value)
            .flatMap{self.trainStationsAndRoutes.validTrainRoutes($0.0!, $0.1!)}
            .flatMap{self.trainAPI.getTrainSchedule($0)}
            .eraseToAnyPublisher()
    }
    
    private var passengersResult: AnyPublisher<(ActionPassengersResult, [Passenger]?), Never> {
        $inputPassengersForAction
            .flatMap(actionPassengers.action)
            .eraseToAnyPublisher()
    }
   
    init(
        actionPassengers: ActionPassengersProtocol = ActionPassengers(),
        dataTrain: TrainAPIProtocol = TrainApi(),
        dataTrainSchedule: TrainScheduleProtocol = TrainSchedule(),
        trainStationsAndRoutes: TrainStationsAndRoutesProtocol = TrainStationsAndRoutes(inputFile: "tutu_routes.csv")
    ) {
        self.actionPassengers = actionPassengers
        self.trainAPI = dataTrain
        self.trainScheduleProtocol = dataTrainSchedule
        self.trainStationsAndRoutes = trainStationsAndRoutes
        imagesBackground = Const.imagesBackground
        buttonsMain = Const.buttonsMain
        
        Publishers.CombineLatest4($departure, $arrival, $mainMenuTabSelected, $isSearch)
            .filter{$0.3}
            .filter{$0.2 == .all}
            .filter{$0.0 != nil && $0.1 != nil}
            .filter{!$0.0!.name.isEmpty && !$0.1!.name.isEmpty}
            .map{($0.0, $0.1)}
            .flatMap{self.getTrips($0).asResult()}
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$trainSchedule)
        
        $inputTrainScheduleForSort
            .filter{!$0.0.isEmpty}
            .flatMap(self.trainScheduleProtocol.sort)
            .asResult()
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$trainSchedule)
     
        passengersResult
            .filter{$0.1 != nil}
            .map{$0.1!}
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$passengers)
        
        passengersResult
            .filter{$0.0 != .ok}
            .map{$0.0}
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$actionPassengersResult)
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var backgroundMain = "day_snow"
    @Published var imagesBackground: [String] = []
    @Published var buttonsMain: [MainMenuTab] = []
    
    private struct Const {
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
    
    func changeCity() {
        (arrival, departure) = (departure, arrival)
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

