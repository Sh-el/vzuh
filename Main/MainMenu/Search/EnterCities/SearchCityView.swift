//
//  WhereFromView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 06.01.2023.
//

import SwiftUI

struct SearchCityView: View {
    @EnvironmentObject var mainVM: MainVM
    @EnvironmentObject var searchingCities: SearchingCities
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

//            TextField((place == .departure ?
//            model.departure?.name : model.arrival?.name) ?? "",
//        text: $searching.city)
            TextField(place == .departure ?
                      "Введите место отправления" : "Введите место прибытия",
                      text: $searchingCities.city)
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
        .onAppear {
            searchingCities.city = ""
        }
    }
}

struct WhereFromView_Previews: PreviewProvider {
    static let mainVM = MainVM()
    static let searchingCities = SearchingCities()

    static var previews: some View {
        SearchCityView(place: .arrival)
            .environmentObject(mainVM)
            .environmentObject(searchingCities)
    }
}
