//
//  TrainRoute.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 18.01.2023.
//

import SwiftUI

struct TrainRoute: Hashable, Identifiable {
    let id = UUID()
    var departureStationId: String = ""
    var departureStationName: String = ""
    var arrivalStationId: String = ""
    var arrivalStationName: String = ""
}
