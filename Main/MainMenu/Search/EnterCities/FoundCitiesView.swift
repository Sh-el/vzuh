//
//  MainCitiesView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 14.01.2023.
//

import SwiftUI

struct FoundCitiesView: View {
    @EnvironmentObject var mainVM: MainVM
    @EnvironmentObject var searchingCities: SearchingCities
    @Environment(\.dismiss) private var dismiss

    let place: EnterCitiesView.Place?

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                if searchingCities.city.isEmpty {
                    MyCityView(place: place)
                }

                switch searchingCities.autocompleteCities {
                case .success(let result):
                    VStack {
                        ForEach(result, id: \.id) {city in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(city.name)
                                        .font(.headline)
                                    Spacer()
                                    HStack(spacing: 10) {
                                        Image(systemName: "bed.double")
                                        Image(systemName: "tram")
                                        Image(systemName: "airplane")
                                    }
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                }
                                Text(city.countryName)
                                    .foregroundColor(.gray)
                                    .font(.callout)
                            }
                            .padding(.vertical, 5)
                            .onTapGesture {
                                if place == .departure {
                                    mainVM.departure = searchingCities.getLocation(city)
                                } else if place == .arrival {
                                    mainVM.arrival = searchingCities.getLocation(city)
                                }
                                dismiss()
                            }
                        }
                    }
                case .none:
                    EmptyView()
                case .some(.failure):
                    EmptyView()
                }
            }
        }
        .onAppear {
            searchingCities.isMyCity = true
        }
    }
}

struct MainCitiesView_Previews: PreviewProvider {
    static let mainVM = MainVM()
    static let searchingCitites = SearchingCities()
    static var previews: some View {
        FoundCitiesView(place: .departure)
            .environmentObject(mainVM)
            .environmentObject(searchingCitites)
    }
}
