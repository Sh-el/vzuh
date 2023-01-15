//
//  WhereFromView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 06.01.2023.
//

import SwiftUI

struct SearchCityView: View {
    @EnvironmentObject var model: MainModel
    @EnvironmentObject var searching: SearchingCities
    @Environment(\.dismiss) private var dismiss
    
    let isWhere: EnterCitiesView.IsPlace?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text(isWhere == .departure ? "Откуда" : "Куда")
                    .font(.headline)
                Spacer()
            }
            
            TextField((isWhere == .departure ? model.departure?.name : model.arrival?.name) ?? "", text: $searching.city)
                .font(.title)
                .fontWeight(.semibold)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            FoundCitiesView(isWhere: isWhere)
            Spacer()
        }
        .padding()
        .foregroundColor(.black)
    }
}

struct WhereFromView_Previews: PreviewProvider {
    static let model = MainModel()
    static let searching = SearchingCities()
    
    static var previews: some View {
        SearchCityView(isWhere: .arrival)
            .environmentObject(model)
            .environmentObject(searching)
    }
}
