//
//  vzuhApp.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 28.12.2022.
//

import SwiftUI

@main
struct vzuhApp: App {
    @StateObject var model = MainModel()
    @StateObject var geocoding = Geocoding()
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(model)
                .environmentObject(geocoding)
        }
    }
}
