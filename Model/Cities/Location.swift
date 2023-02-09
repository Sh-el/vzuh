//
//  Location.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.02.2023.
//

import SwiftUI

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
