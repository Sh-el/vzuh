//
//  TrainRoute.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.02.2023.
//

import SwiftUI

struct TrainRoute: Hashable, Identifiable {
    let id = UUID()
    let departureStationId: String
    let departureStationName: String
    let arrivalStationId: String
    let arrivalStationName: String

    init(departureStationId: String = "",
         departureStationName: String = "",
         arrivalStationId: String = "",
         arrivalStationName: String = "") {
        self.departureStationId = departureStationId
        self.departureStationName = departureStationName
        self.arrivalStationId = arrivalStationId
        self.arrivalStationName = arrivalStationName
    }
}
