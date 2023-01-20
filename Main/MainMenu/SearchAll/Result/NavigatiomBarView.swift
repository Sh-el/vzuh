//
//  NavigatiomBarView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 17.01.2023.
//

import SwiftUI

struct NavigatiomBarView: View {
    @EnvironmentObject var model: MainModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
            }
            VStack(alignment: .leading) {
//                Text((model.departure?.name ?? "") + " - " + (model.arrival?.name ?? ""))
//                    .fontWeight(.semibold)
                HStack {
                    Text(model.isDateBack ? model.dateDeparture.dateToString + " - " + model.dateBack.dateToString : model.dateDeparture.dateToString + ".")
                    Text(model.numberPassengers() == 1 ? "\(model.numberPassengers()) пассажир" : "\(model.numberPassengers()) пассажира")
                }
                .font(.callout)
                TitleResultView()
            }
            .padding(.vertical, 20)
        }
        .foregroundColor(.white)
    }
}

struct NavigatiomBarView_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        NavigatiomBarView()
            .environmentObject(model)
    }
}
