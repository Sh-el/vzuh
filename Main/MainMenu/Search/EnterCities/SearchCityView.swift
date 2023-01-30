//
//  WhereFromView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 06.01.2023.
//

import SwiftUI

struct SearchCityView: View {
    @EnvironmentObject var model: MainVM
    @EnvironmentObject var searching: SearchingCities
    @Environment(\.dismiss) private var dismiss
    
    let place: EnterCitiesView.Place?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text(place == .departure ? "Откуда" : "Куда")
                    .font(.headline)
                Spacer()
            }
            
//            TextField((place == .departure ? model.departure?.name : model.arrival?.name) ?? "", text: $searching.city)
            TextField(place == .departure ? "Введите место отправления" : "Введите место прибытия", text: $searching.city)
                .font(.title)
                .fontWeight(.semibold)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            FoundCitiesView(place: place)
            Spacer()
        }
        .padding()
        .foregroundColor(.black)
        .onAppear{
            searching.city = ""
        }
        .onDisappear{
            print("dis")
        }
    }
}

struct WhereFromView_Previews: PreviewProvider {
    static let model = MainVM()
    static let searching = SearchingCities()
    
    static var previews: some View {
        SearchCityView(place: .arrival)
            .environmentObject(model)
            .environmentObject(searching)
    }
}
