//
//  ResultAddPassengers.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.01.2023.
//

import Foundation

struct ResultAddPassengers {
    enum Error: String {
        case fewAdults = "Взрослых не может быть меньше, чем детей младше двух лет!"
        case lotsPassengers = "Можно выбрать не больше, чем четыре пассажира!"
        case fewPassengers = "Можно выбрать не менее одного взрослого пассажира!"
        case lotsBabies = "Детей до двух лет должно быть не больше, чем взрослых!"
        case everythingOk
    }
    
    var error: Error
    let isMaxPassengers: Bool
}
