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
    
    let isWhere: EnterCitiesView.IsPlace?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                if searching.city.isEmpty {
                    switch searching.myCity {
                    case .success(let result):
                        VStack(alignment: .leading) {
                            HStack {
                                Text(result.name)
                                    .font(.headline)
                                    .padding(.trailing, 10)
                                Image(systemName: "location.fill")
                                    .foregroundColor(.gray)
                            }
                            Text(result.countryName)
                                .font(.callout)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 5)
                    case .none:
                        Text("loading")
                    case .some(.failure(_)):
                        Text("error")
                    }
                }
                
                LazyVStack(alignment: .leading) {
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
                                    if isWhere == .departure {
                                        model.departure = searching.getLocation(city)
                                        print("Dep")
                                    } else if isWhere == .arrival {
                                        model.arrival = searching.getLocation(city)
                                        print("Arr")
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
}

struct MainCitiesView_Previews: PreviewProvider {
    static let model = MainModel()
    static let searching = SearchingCities()
    static var previews: some View {
        FoundCitiesView(isWhere: .departure)
            .environmentObject(model)
            .environmentObject(searching)
    }
}
