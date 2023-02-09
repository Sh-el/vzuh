//
//  AllFindView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 30.12.2022.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var mainVM: MainVM
    
    var body: some View {
        VStack(alignment: .leading) {
            EnterCitiesView()
            Divider()
            DateSelectionView()
            Divider()
            PassengersView()
            Divider()
            NavigationLink(destination: searchDestinationView) {
                searchButton
            }
            .disabled(mainVM.departure?.name == mainVM.arrival?.name)
        }
    }
    
    @ViewBuilder
    private var searchDestinationView: some View {
        switch mainVM.mainMenuTabSelected {
        case .all:
            AllResultsView()
        case .hotels:
            HotelsResultView()
        case .flights:
            FlightsResultView()
        case .train:
            TrainsResultView()
        case .bus:
            BusResultView()
        }
    }
    
    private var searchButton: some View {
        Text("Найти")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(.blue.gradient)
            .cornerRadius(5)
            .padding(.horizontal, 10)
    }
}

struct AllFindView_Previews: PreviewProvider {
    static let mainVM = MainVM()
    
    static var previews: some View {
        SearchView()
            .environmentObject(mainVM)
    }
}
