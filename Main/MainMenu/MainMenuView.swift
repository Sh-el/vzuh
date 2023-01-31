//
//  MainMenuView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 30.12.2022.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var model: MainVM

    var body: some View {
        TabView(selection: $model.mainMenuTabSelected) {
            VStack(alignment: .leading) {
                Spacer()
                ButtonsMainMenuView()
                    .padding(.bottom, 10)
                SearchView()
                    .foregroundColor(.white)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static let model = MainVM()
    static var previews: some View {
        MainMenuView()
            .environmentObject(model)
    }
}
