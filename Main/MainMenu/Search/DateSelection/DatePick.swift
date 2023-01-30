//
//  DatePick.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 01.01.2023.
//

import SwiftUI

struct DatePick: View {
    @EnvironmentObject var model: MainVM
    let dateTrip: DateSelectionView.DateTrip?
    
    var body: some View {
        VStack {
            if dateTrip == .dateDeparture {
                Text((model.departure?.name ?? "") + " - " + (model.arrival?.name ?? ""))
                    .font(.largeTitle)
            } else {
                Text((model.arrival?.name ?? "") + " - " + (model.departure?.name ?? ""))
                    .font(.largeTitle)
            }
            DatePicker("",
                       selection: dateTrip == .dateDeparture ?
                       $model.dateDeparture: $model.dateBack,
                       in: Date.now...,
                       displayedComponents: [.date])
            .datePickerStyle(.graphical)
            Spacer()
        }
        .foregroundColor(.black)
        .padding()
        .onDisappear{
            if dateTrip == .dateDeparture && model.dateBack < model.dateDeparture {
                model.dateBack = model.dateDeparture
            } else if dateTrip == .dateBack && model.dateDeparture > model.dateBack {
                model.dateDeparture = model.dateBack
            }
        }
    }
}

struct DatePick_Previews: PreviewProvider {
    static let model = MainVM()
    static var previews: some View {
        DatePick(dateTrip: .dateDeparture)
            .environmentObject(model)
    }
}
