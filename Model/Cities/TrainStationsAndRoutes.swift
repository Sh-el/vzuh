//
//  Routes.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 06.01.2023.
//

import SwiftUI
import Combine

protocol TrainStationsAndRoutesProtocol {
    func getTrainStationsNames() -> [String : String]
    func getTrainRoutes() -> [TrainRoute]
    func validTrainRoutes(_ departure: Location, _ arrival: Location) -> AnyPublisher<[TrainRoute], Error>
}

struct TrainStationsAndRoutes: TrainStationsAndRoutesProtocol {
    let inputFile: String
    
    func validTrainRoutes(_ departure: Location, _ arrival: Location) -> AnyPublisher<[TrainRoute], Error> {
        Publishers.Zip(Just(departure), Just(arrival))
            .map{(Set($0.0.routes), Set($0.1.routes))}
            .map{Array($0.0.intersection($0.1)).filter{$0.departureStationName.lowercased().contains(departure.name.lowercased())}}
            .tryMap{value in
                if value.isEmpty {
                    throw RequestError.invalidRequest
                }
                return value
            }
            .eraseToAnyPublisher()
    }
 
    func getTrainStationsNames() -> [String : String] {
        if let filepath = Bundle.main.path(forResource: inputFile, ofType: nil) {
            do {
                let fileContent = try String(contentsOfFile: filepath)
                let lines = fileContent.components(separatedBy: "\n")
                var resultsDict: [String: String] = [:]
                
                lines.dropFirst().forEach {line in
                    let data = line.components(separatedBy: ";")
                    if data.count == 4 {
                        if resultsDict[data[0]] == nil {
                            resultsDict[data[0]] = data[1]
                        }
                    }
                }
                return resultsDict
            } catch {
                print("error: \(error)")
            }
        } else {
            print("\(inputFile) could not be found")
        }
        return [:]
    }
    
    func getTrainRoutes() -> [TrainRoute] {
        if let filepath = Bundle.main.path(forResource: inputFile, ofType: nil) {
            do {
                let fileContent = try String(contentsOfFile: filepath)
                let lines = fileContent.components(separatedBy: "\n")
                var resultsArr: [TrainRoute] = []
                
                lines.dropFirst().forEach {line in
                    let data = line.components(separatedBy: ";")
                    if data.count == 4 {
                        var routElement = TrainRoute()
                        routElement.departureStationId = data[0]
                        routElement.departureStationName = data[1]
                        routElement.arrivalStationId = data[2]
                        routElement.arrivalStationName = data[3]
                        resultsArr.append(routElement)
                    }
                }
                return resultsArr
            } catch {
                print("error: \(error)")
            }
        } else {
            print("\(inputFile) could not be found")
        }
        return []
    }
    
}

struct TrainRoute: Hashable, Identifiable {
    let id = UUID()
    var departureStationId: String = ""
    var departureStationName: String = ""
    var arrivalStationId: String = ""
    var arrivalStationName: String = ""
}


