//
//  ContentView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 28.12.2022.
//

import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        TabView {
            MainView()
            OrdersView()
            HelpView()
            ProfileView()
        }
        .accentColor(.purple)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let model = MainModel()
    
    static var previews: some View {
        WelcomeView()
            .environmentObject(model)
    }
}
