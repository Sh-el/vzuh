//
//  Routes.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 06.01.2023.
//

import Foundation

struct Routes {
    struct Station: Hashable {
        var id = UUID()
        var stationId: String = ""
        var stationName: String = ""
    //    var arrivalStationId: String = ""
    //    var arrivalStationName: String = ""
    }
 
    func readCSV1(inputFile: String) -> [String : String] {
        if let filepath = Bundle.main.path(forResource: inputFile, ofType: nil) {
            do {
                let fileContent = try String(contentsOfFile: filepath)
                let lines = fileContent.components(separatedBy: "\n")
                var resultsDict: [String: String] = [:]
                
                lines.dropFirst().forEach {line in
                    let data = line.components(separatedBy: ";")
                    if data.count == 4 {
                        if resultsDict[data[1]] == nil {
                            resultsDict[data[1]] = data[0]
                        }
                    }
                }
                print("readCSV")
                return resultsDict
            } catch {
                print("error: \(error)")
            }
        } else {
            print("\(inputFile) could not be found")
        }
        
        return [:]
    }
    
}




