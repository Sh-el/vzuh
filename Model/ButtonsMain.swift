//
//  ButtonsStore.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 30.12.2022.
//

import Foundation

enum ButtonsMain {
    case all
    case hotels
    case airplane
    case train
    case bus
    
    var imageName: String {
        switch self {
        case .all:
            return "globe"
        case .hotels:
            return "bed.double"
        case .airplane:
            return "airplane"
        case .train:
            return "tram"
        case .bus:
            return "bus"
        }
    }
}



