//
//  vzuhApp.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 28.12.2022.
//

import SwiftUI

@main
struct VzuhApp: App {
    @StateObject var model: MainVM = .init()
    @StateObject var searching: SearchingCities = .init()

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
