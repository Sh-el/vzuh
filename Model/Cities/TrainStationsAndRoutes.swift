//
//  Routes.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 06.01.2023.
//

import SwiftUI
import Combine

protocol TrainStationsAndRoutesProtocol {
    func getTrainStationsNames() -> [String: String]
    func getTrainRoutes() -> [TrainRoute]
    func validTrainRoutes(_ departure: Location, _ arrival: Location) -> AnyPublisher<[TrainRoute], Error>
}

struct TrainStationsAndRoutes: TrainStationsAndRoutesProtocol {
    let inputFile: String

    func validTrainRoutes(_ departure: Location, _ arrival: Location) -> AnyPublisher<[TrainRoute], Error> {
        Publishers.Zip(Just(departure), Just(arrival))
            .map {(Set($0.0.routes), Set($0.1.routes))}
            .map {Array($0.0.intersection($0.1))
                    .filter {$0.departureStationName
                            .lowercased()
                        .contains(departure.name.lowercased())}}
            .tryMap {value in
                if value.isEmpty {
                    throw RequestError.invalidRequest
                }
                return value
            }
            .eraseToAnyPublisher()
    }

    func getTrainStationsNames() -> [String: String] {
        guard let filepath = Bundle.main.path(forResource: inputFile, ofType: nil) else {
            print("(inputFile) could not be found")
            return [:]
        }
        do {
            let fileContent = try String(contentsOfFile: filepath)
            let lines = fileContent.components(separatedBy: "\n")
            var resultsDict: [String: String] = [:]

            lines.dropFirst().forEach { line in
                let data = line.components(separatedBy: ";")
                if data.count == 4 {
                    let key = data[0]
                    let value = data[1]

                    if resultsDict[key] == nil {
                        resultsDict[key] = value
                    }
                }
            }
            return resultsDict
        } catch {
            print("error: \(error)")
            return [:]
        }
    }

    func getTrainRoutes() -> [TrainRoute] {
        guard let filepath = Bundle.main.path(forResource: inputFile, ofType: nil) else {
            print("(inputFile) could not be found")
            return []
        }
        do {
            let fileContent = try String(contentsOfFile: filepath)
            let lines = fileContent.components(separatedBy: "\n")
            return lines.dropFirst().compactMap { line -> TrainRoute? in
                let data = line.components(separatedBy: ";")
                if data.count == 4 {
                    return TrainRoute(departureStationId: data[0],
                                      departureStationName: data[1],
                                      arrivalStationId: data[2],
                                      arrivalStationName: data[3])
                }
                return nil
            }
        } catch {
            print("error: \(error)")
            return []
        }
    }

}

struct TrainRoute: Hashable, Identifiable {
    let id = UUID()
    var departureStationId: String = ""
    var departureStationName: String = ""
    var arrivalStationId: String = ""
    var arrivalStationName: String = ""
}
