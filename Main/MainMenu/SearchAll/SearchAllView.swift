//
//  AllFindView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 30.12.2022.
//

import SwiftUI

struct SearchAllView: View {
        
    var body: some View {
        VStack(alignment: .leading) {
            EnterCitiesView()
            Divider()
            DateSelectionView()
            Divider()
            PassengersView()
            Divider()
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
    }
}

struct AllFindView_Previews: PreviewProvider {
    static let model = MainModel()
    
    static var previews: some View {
        SearchAllView()
            .environmentObject(model)
    }
}
