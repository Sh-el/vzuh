//
//  WhereFromView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 06.01.2023.
//

import SwiftUI

struct SearchCityView: View {
    @EnvironmentObject var model: MainModel
    @EnvironmentObject var geocoding :Geocoding
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
            .autocapitalization(.none)
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(geocoding.stations.sorted(by: <), id:\.key) {stationName, stationId in
                        HStack {
                            Text(stationName)
                            Text(stationId)
                        }
                        .onTapGesture {
                            if isWhere == .whereFrom {
                                model.departure = MainModel.Station(stationId: stationId, stationName: stationName)
                                dismiss()
                            } else if isWhere == .whereTo {
                                model.arrival = MainModel.Station(stationId: stationId, stationName: stationName)
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .foregroundColor(.black)
    }
}

struct WhereFromView_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        SearchCityView(isWhere: .whereTo)
            .environmentObject(model)
    }
}
