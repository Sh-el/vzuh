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
        VStack {
            Spacer()
            ButtonsMainMenuView(selectedTab: $selectedTab)
            TabView(selection: $selectedTab) {
                SelectedView(selectedTab: selectedTab)
                    .foregroundColor(.white)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 200)
            NavigationLink(destination: SearchAllResultView()) {
                searchButton
            }
        }
    }
    var searchButton: some View {
        Text("Найти")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(.blue)
            .cornerRadius(5)
            .padding(.horizontal, 10)
            .padding(.bottom, 90)
    }

}

struct MainMenuView_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        MainMenuView()
            .environmentObject(model)
    }
}
