//
//  SearchAllResultView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.01.2023.
//

import SwiftUI

struct SearchAllResultView: View {
    @EnvironmentObject var model: MainModel
    @EnvironmentObject var searching: SearchingCities
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Text(model.departure?.name ?? "")
                Text(model.departure?.routes.count.description ?? "")

                switch model.trainSchedule {
                case .success(let schedule):
                    LazyVStack {
                    ForEach(schedule, id: \.url) {value in
                        
                            Text(value.url)
                        
                        LazyVStack {
                            ForEach(value.trips, id: \.id) {trip in
                                Text(trip.categories.description)
                            }
                        }
                        }
                    }
                case .none:
                    Text("loading")
                case .some(.failure(_)):
                    Text("error")
                }
                

                
            }

        }
        .onAppear{
            model.getTrainSchedule()
        }
    }
}

struct SearchAllResultView_Previews: PreviewProvider {
    static let model = MainModel()
    static let searching = SearchingCities()
    static var previews: some View {
        SearchAllResultView()
            .environmentObject(model)
            .environmentObject(searching)
    }
}
