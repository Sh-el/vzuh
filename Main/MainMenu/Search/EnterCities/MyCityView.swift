//
//  MyCityView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 24.01.2023.
//

import SwiftUI

struct MyCityView: View {
    @EnvironmentObject var mainVM: MainVM
    @EnvironmentObject var searchingCities: SearchingCities
    @Environment(\.dismiss) private var dismiss

    let place: EnterCitiesView.Place?

    var body: some View {
        switch searchingCities.myCity {
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
                    mainVM.departure = searchingCities.getLocation(result)
                } else if place == .arrival {
                    mainVM.arrival = searchingCities.getLocation(result)
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
    static let mainVM = MainVM()
    static let searchingCities = SearchingCities()
    static var previews: some View {
        MyCityView(place: .departure)
            .environmentObject(mainVM)
            .environmentObject(searchingCities)
    }
}
