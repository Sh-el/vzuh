//
//  AllFindView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 30.12.2022.
//

import SwiftUI

struct SearchAllView: View {
    @EnvironmentObject var model: MainModel
    let selectedTab: ButtonsMain
    
    var body: some View {
        VStack(alignment: .leading) {
            EnterCitiesView(selectedTab: selectedTab)
            Divider()
            DateSelectionView()
            Divider()
            PassengersView()
            Divider()
            
            switch selectedTab {
            case .all:
                NavigationLink(destination: AllResultsView()) {
                    searchButton
                }
                .disabled(model.departure?.name == model.arrival?.name)
            case .hotels:
                NavigationLink(destination: AllResultsView()) {
                    searchButton
                }
            case .airplane:
                NavigationLink(destination: AllResultsView()) {
                    searchButton
                }
            case .train:
                NavigationLink(destination: AllResultsView()) {
                    searchButton
                }
            case .bus:
                NavigationLink(destination: AllResultsView()) {
                    searchButton
                }
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
    }
}

struct AllFindView_Previews: PreviewProvider {
    static let model = MainModel()
    
    static var previews: some View {
        SearchAllView(selectedTab: .all)
            .environmentObject(model)
    }
}
