//
//  ButtonsTopView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 16.01.2023.
//

import SwiftUI

struct TitleResultView: View {
    @EnvironmentObject var model: MainVM

    var body: some View {
        HStack(alignment: .top) {
            switch model.trainSchedule {
            case .success(let schedule):
                if let trip = model.trainMinPrice(schedule: schedule) {
                    HStack {
                        Text("Цены от")
                        Spacer()
                        Text(trip.categories.min()?.price != nil ? "\(trip.categories.min()!.price) \u{20BD}," : "")
                        Text("номер поезда - " + trip.trainNumber)
                    }
                } else {
                    Text("void")
                }
            case .none:
                EmptyView()
            case .some(.failure):
                EmptyView()
            }
        }
    }

}

struct ButtonsTopView_Previews: PreviewProvider {
    static let model = MainVM()
    static var previews: some View {
        TitleResultView()
            .environmentObject(model)
    }
}
