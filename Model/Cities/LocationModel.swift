//
//  Location.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.02.2023.
//

import SwiftUI
typealias Location = LocationModel.Location

protocol LocationProtocol {
    func getLocation(_ element: AutocompleteCityElement) -> Location
}

struct LocationModel: LocationProtocol {
    private let trainStationsAndRoutes: TrainStationsAndRoutesProtocol

    private var allStations: [String: String] = [:]
    private var allTrainRoutes: [TrainRoute] = []

    func getLocation(_ element: AutocompleteCityElement) -> Location {
        var location = Location()

        location.name = element.name
        location.countryName = element.countryName
        location.codeIATA = element.code

        location.trainStationId = allStations.compactMap {
            $0.value.lowercased().contains(element.name.lowercased()) ? $0.key : nil
        }

        location.routes = allTrainRoutes.filter {
            $0.departureStationName.contains(element.name) || $0.arrivalStationName.contains(element.name)
        }

        return location
    }

    init(trainStationsAndRoutes:
         TrainStationsAndRoutesProtocol = TrainStationsAndRoutesModel(inputFile: "tutu_routes.csv")) {
        self.trainStationsAndRoutes = trainStationsAndRoutes

        allStations = trainStationsAndRoutes.getTrainStationsNames()
        allTrainRoutes = trainStationsAndRoutes.getTrainRoutes()
    }
}

extension LocationModel {
    struct Location: Identifiable {
        let id = UUID()
        var name: String
        var countryName: String
        var codeIATA: String
        var trainStationId: [String]
        var routes: [TrainRoute]

        init(name: String = "",
             countryName: String = "",
             codeIATA: String = "",
             trainStationId: [String] = [],
             routes: [TrainRoute] = []) {

            self.name = name
            self.countryName = countryName
            self.codeIATA = codeIATA
            self.trainStationId = trainStationId
            self.routes = routes
        }
    }
}
