//
//  Geocoding.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.01.2023.
//

import Foundation
import Combine

final class Geocoding: ObservableObject {
    private var routes = Routes()
    @Published private var allStations: [String : String] = [:]
    
    //Input
    @Published var city = ""
    
    //Output
    @Published var stations: [String : String] = [:]
    
    private func readCSV() -> [String : String] {
        return routes.readCSV1(inputFile: "tutu_routes.csv")
    }
    
    func stationName(_ stationId: String) -> String  {
        let allStaions = allStations
        let resultDict = allStaions.first(where: {key, value in
            value == stationId
        })
        return resultDict?.key ?? "No Name"
    }
    
    init() {
        allStations = readCSV()
        
        Publishers.CombineLatest($allStations, $city)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map{allStations1, city in
                allStations1.filter{$0.key.contains(city)}
            }
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$stations)
    }
    
}

//final class GeocodingCache: ObservableObject {
//    static let shared = GeocodingCache()
//    private init() {}
//
//    var loaders: NSCache<NSString, Geocoding> = NSCache()
//
//    func loader() -> Geocoding {
//        let key = NSString(string: "Geocoding")
//        if let loader = loaders.object(forKey: key) {
//            print("loaders.object(forKey: key)")
//            return loader
//        } else {
//            let loader = Geocoding()
//            loaders.setObject(loader, forKey: key)
//            print("loaders.setObject(loader, forKey: key)")
//            return loader
//        }
//    }
//
//    func removeAllObjects() {
//            self.loaders.removeAllObjects()
//        }
//}
