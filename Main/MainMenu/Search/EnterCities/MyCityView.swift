//
//  MyCityView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 24.01.2023.
//

import SwiftUI

struct MyCityView: View {
    @EnvironmentObject var model: MainVM
    @EnvironmentObject var searching: SearchingCities
    @Environment(\.dismiss) private var dismiss

    let place: EnterCitiesView.Place?

    var body: some View {
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
            .onTapGesture {
                if place == .departure {
                    model.departure = searching.getLocation(result)
                } else if place == .arrival {
                    model.arrival = searching.getLocation(result)
                }
                dismiss()
            }
        case .none:
            Text("loading")
        case .some(.failure):
            Text("error")
        }
    }
}

struct MyCityView_Previews: PreviewProvider {
    static let model = MainVM()
    static let searching = SearchingCities()
    static var previews: some View {
        MyCityView(place: .departure)
            .environmentObject(model)
            .environmentObject(searching)
    }
}
