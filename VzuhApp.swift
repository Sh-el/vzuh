//
//  vzuhApp.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 28.12.2022.
//

import SwiftUI

@main
struct VzuhApp: App {
    @StateObject var model = MainVM()
    @StateObject var searching = SearchingCities()

    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(model)
                .environmentObject(searching)
                .task {

                }
        }

    }
}
