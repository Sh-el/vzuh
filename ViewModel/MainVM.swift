//
//  Model.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 02.01.2023.
//

import SwiftUI
import Combine

protocol MainVmProtocol: ObservableObject {
    func trainMinPrice(schedule: [TrainTrip]) -> TrainTrip?
    var backgroundMain: String {get}
}

final class MainVM: MainVmProtocol {
    @Published var mainMenuTabSelected: MainMenuTab = .all
    @Published var isSearch = false

    @Published var departure: Location?
    @Published var arrival: Location?

    @Published var dateDeparture = Date.now
    @Published var dateBack = Date.now
    @Published var isDateBack = false

    // Passengers
    private let passengersManager: PassengersManagerProtocol
    @Published var passengers: [Passenger] = [.adult]
    @Published var actionNumberPassengers: ActionNumberPassengers?
    @Published var changeNumberPassengersError: ChangeNumberPassengersError  = .valid

    private func changeNumberPassengers() {
        let changeNumberPassengersRes = $actionNumberPassengers
            .compactMap {$0}
            .map {[weak self] action in
                guard let passengers = self?.passengers else {
                    return ([.adult], action)
                }
                return (passengers, action)
            }
            .flatMap(passengersManager.changeNumberPassengers)
            .eraseToAnyPublisher()

        changeNumberPassengersRes
            .compactMap {$0.1}
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$passengers)

        changeNumberPassengersRes
            .filter {$0.0 != .valid}
            .map {$0.0}
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$changeNumberPassengersError)
    }

    // Train
    typealias TrainSchedules = Result<[TrainTrip], Error>
    private let trainStationsAndRoutes: TrainStationsAndRoutesProtocol
    private let dataTrain: TrainAPIProtocol
    private let dataTrainSchedule: TrainProtocol

    @Published var trainSchedules: TrainSchedules?
    @Published var choiceSortTrainSchedules: TrainModel.Sort?

    private func getTrips(_ value: (Location?, Location?)) -> AnyPublisher<[TrainTrip], Error> {
            Just(value)
                .map {($0.0!, $0.1!)}
                .flatMap(trainStationsAndRoutes.validTrainRoutes)
                .flatMap(dataTrain.getTrainSchedule)
                .eraseToAnyPublisher()
        }

   private func loadTrainSchedules() {
        $isSearch
            .filter {$0}
            .filter {[weak self] _ in self?.mainMenuTabSelected == .all}
            .map {[weak self] _ in (self?.departure, self?.arrival)}
            .compactMap {$0}
            .filter {$0.0 != nil && $0.1 != nil}
//            .flatMap(getTrips)
            .map(getTrips)
            .switchToLatest()
            .asResult()
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$trainSchedules)
    }
        
    private func sortTrainSchedule() {
        $choiceSortTrainSchedules
            .compactMap {$0}
            .map {[weak self] sort  in
                switch self?.trainSchedules {
                case .success(let schedules):
                    return (schedules, sort)
                case nil, .failure:
                    return ([], nil)
                }
            }
            .filter {!$0.0.isEmpty}
            .flatMap(dataTrainSchedule.sort)
            .asResult()
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$trainSchedules)
    }

    func trainMinPrice(schedule: [TrainTrip]) -> TrainTrip? {
        dataTrainSchedule.minPrice(in: schedule)
    }

    init(
        passengersManager: PassengersManagerProtocol = PassengersManager(),
        dataTrain: TrainAPIProtocol = TrainApi(),
        dataTrainSchedule: TrainProtocol = TrainModel(),
        trainStationsAndRoutes: TrainStationsAndRoutesProtocol =
                                    TrainStationsAndRoutesModel(inputFile: "tutu_routes.csv")
    ) {
        self.passengersManager = passengersManager
        self.dataTrain = dataTrain
        self.dataTrainSchedule = dataTrainSchedule
        self.trainStationsAndRoutes = trainStationsAndRoutes

        imagesBackground = Constants.imagesBackground
        buttonsMain = Constants.buttonsMain

        changeNumberPassengers()
        loadTrainSchedules()
        sortTrainSchedule()
    }

    @Published var backgroundMain = "day_snow"
    @Published var imagesBackground: [String] = []
    @Published var buttonsMain: [MainMenuTab] = []

    private struct Constants {
        static let imagesBackground = ["day_snow",
                                       "snow_mountain",
                                       "day_clearsky",
                                       "day_cloudy",
                                       "night_clearsky",
                                       "tokyo-station"]

        static let buttonsMain: [MainMenuTab] = [.all, .flights, .train, .bus]
    }

    func convertSecondsToHrMinute(seconds: String) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru")
        formatter.calendar = calendar

        if let seconds = Int(seconds) {
            let formattedString = formatter.string(from: TimeInterval(seconds))!
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
            .catch {error in
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
