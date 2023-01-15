//
//  Routes.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 06.01.2023.
//

import SwiftUI

struct Station: Hashable, Identifiable {
    var id = UUID()
    var stationId: String = ""
    var stationName: String = ""
}

struct Route: Hashable, Identifiable {
    let id = UUID()
    var departureStationId: String = ""
    var departureStationName: String = ""
    var arrivalStationId: String = ""
    var arrivalStationName: String = ""
}

protocol DataTrainStationsProtocol {
    func getTrainStationsName() -> [String : String]
    func getTrainRoutes() -> [Route]
}

struct TrainStation: DataTrainStationsProtocol {
    let inputFile: String
 
    func getTrainStationsName() -> [String : String] {
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
    
    func getTrainRoutes() -> [Route] {
        if let filepath = Bundle.main.path(forResource: inputFile, ofType: nil) {
            do {
                let fileContent = try String(contentsOfFile: filepath)
                let lines = fileContent.components(separatedBy: "\n")
                var resultsArr: [Route] = []
                
                lines.dropFirst().forEach {line in
                    let data = line.components(separatedBy: ";")
                    if data.count == 4 {
                        var routElement = Route()
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




