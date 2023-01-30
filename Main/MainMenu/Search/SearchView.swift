//
//  AllFindView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 30.12.2022.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var model: MainVM
    
    var body: some View {
        VStack(alignment: .leading) {
            EnterCitiesView()
            Divider()
            DateSelectionView()
            Divider()
            PassengersView()
            Divider()
            
            switch model.mainMenuTabSelected {
            case .all:
                NavigationLink(destination: AllResultsView()) {
                    searchButton
                }
                .disabled(model.departure?.name == model.arrival?.name)
            case .hotels:
                NavigationLink(destination: HotelsResultView()) {
                    searchButton
                }
            case .flights:
                NavigationLink(destination: FlightsResultView()) {
                    searchButton
                }
            case .train:
                NavigationLink(destination: TrainsResultView()) {
                    searchButton
                }
            case .bus:
                NavigationLink(destination: BusResultView()) {
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
    static let model = MainVM()
    
    static var previews: some View {
        SearchView()
            .environmentObject(model)
    }
}
