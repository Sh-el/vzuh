//
//  MainMenuView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 30.12.2022.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var model: MainModel
    @State private var selectedTab = ButtonsMain.all
    
    var body: some View {
            TabView(selection: $selectedTab) {
                VStack(alignment: .leading) {
                    Spacer()
                    ButtonsMainMenuView(selectedTab: $selectedTab)
                        .padding(.bottom, 10)
                    SearchAllView(selectedTab: selectedTab)
                        .foregroundColor(.white)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
  
    }
  
}

struct MainMenuView_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        MainMenuView()
            .environmentObject(model)
    }
}
