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
            MainTabView(mainVM: MainVM())
            OrdersTabView()
            HelpTabView()
            ProfileTabView()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static let model = MainVM()

    static var previews: some View {
        WelcomeView()
            .environmentObject(model)
    }
}
