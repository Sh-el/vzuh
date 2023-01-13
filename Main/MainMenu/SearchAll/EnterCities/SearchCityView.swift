//
//  WhereFromView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 06.01.2023.
//

import SwiftUI

struct SearchCityView: View {
    @EnvironmentObject var model: MainModel
    @EnvironmentObject var geocoding: Searching
    @Environment(\.dismiss) private var dismiss
    
    let isWhere: EnterCitiesView.IsWhere?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text(isWhere == .whereFrom ? "Откуда" : "")
                Spacer()
            }
        
            TextField(geocoding.city, text: $geocoding.city)
            .font(.largeTitle)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
         
            if geocoding.city.isEmpty {
                ScrollView {
                    
                    VStack(alignment: .leading) {
                        switch geocoding.geocodingCity {
                        case .success(let result):
                            HStack {
                                Text(result.name)
                                Text(result.countryName)
                            }
                        case .none:
                            Text("loading")
                        case .some(.failure(_)):
                            Text("error")
                        }
                        
                        ForEach(geocoding.mainCities, id: \.id) {city in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(city.name)
                                    Spacer()
                                    Image(systemName: city.hotels ? "bed.double" : "")
                                    Image(systemName: city.trainStations ? "tram" : "")
                                    Image(systemName: city.airports ? "airplane" : "")
                                    Image(systemName: city.busStations ? "bus" : "")
                                }
                                .font(.caption)
                                Text(city.description)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        switch geocoding.autocompleteCity {
                        case .success(let result):
                            VStack {
                                ForEach(result, id: \.id) {value in
                                    HStack {
                                        Text(value.name)
                                        Text(value.countryName)
                                    }
                                }
                            }
                        case .none:
                            Text("loading")
                        case .some(.failure(_)):
                            Text("error")
                        }
                        ForEach(geocoding.stations.sorted(by: <), id:\.key) {stationName, stationId in
                            HStack {
                                Text(stationName)
                                Text(stationId)
                            }
                            .onTapGesture {
                                if isWhere == .whereFrom {
                                    model.departure = Station(stationId: stationId, stationName: stationName)
                                    dismiss()
                                } else if isWhere == .whereTo {
                                    model.arrival = Station(stationId: stationId, stationName: stationName)
                                    dismiss()
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .foregroundColor(.black)
    }
}

struct WhereFromView_Previews: PreviewProvider {
    static let model = MainModel()
    static let geocoding = Searching()
    
    static var previews: some View {
        SearchCityView(isWhere: .whereTo)
            .environmentObject(model)
            .environmentObject(geocoding)
    }
}
