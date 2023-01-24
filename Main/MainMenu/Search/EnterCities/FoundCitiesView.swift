//
//  MainCitiesView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 14.01.2023.
//

import SwiftUI

struct FoundCitiesView: View {
    @EnvironmentObject var model: MainModel
    @EnvironmentObject var searching: SearchingCities
    @Environment(\.dismiss) private var dismiss
    
    let place: EnterCitiesView.Place?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                if searching.city.isEmpty {
                    MyCityView(place: place)
                }
                
                switch searching.city.isEmpty ? searching.mainCities : searching.autocompleteCities {
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
                                    model.departure = searching.getLocation(city)
                                } else if place == .arrival {
                                    model.arrival = searching.getLocation(city)
                                }
                                dismiss()
                            }
                        }
                    }
                case .none:
                    EmptyView()
                case .some(.failure(_)):
                    EmptyView()
                }
            }
        }
    }
}

struct MainCitiesView_Previews: PreviewProvider {
    static let model = MainModel()
    static let searching = SearchingCities()
    static var previews: some View {
        FoundCitiesView(place: .departure)
            .environmentObject(model)
            .environmentObject(searching)
    }
}
