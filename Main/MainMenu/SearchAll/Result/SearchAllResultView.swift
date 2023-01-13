//
//  SearchAllResultView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.01.2023.
//

import SwiftUI

struct SearchAllResultView: View {
    @EnvironmentObject var model: MainModel
    @EnvironmentObject var geocoding: Searching
    
    var body: some View {
        VStack {
            switch model.trainSchedule {
            case .success(let trainSchedule):
                ScrollView {
                    VStack {
                        Text(trainSchedule.url)
                        ForEach(trainSchedule.trips, id: \.id) {value in
                            VStack {
                                HStack {
                                    Text(geocoding.stationName(value.departureStation))
                                    Text(geocoding.stationName(value.arrivalStation))
                                }
                                ForEach(value.categories, id: \.type) {categories in
                                    HStack {
                                        Text(categories.type.rawValue)
                                        Text(String(categories.price))
                                        Spacer()
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            case .none:
                Text("loading")
            case .some(.failure(_)):
                Text("error")
            }
        }
        .onAppear {
            model.trainSchedule = nil
            model.getTrainSchedule()
        }
    }
}

struct SearchAllResultView_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        SearchAllResultView()
            .environmentObject(model)
    }
}
