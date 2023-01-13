//
//  DatePick.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 01.01.2023.
//

import SwiftUI

struct DatePick: View {
    @EnvironmentObject var model: MainModel
    let isWhen: DateSelectionView.IsWhen?
    
    var body: some View {
        VStack {
            Text(isWhen == .dateThere ? model.departure.stationName + "-" + model.arrival.stationName :
                    model.arrival.stationName + "-" + model.departure.stationName)
            .font(.largeTitle)
            DatePicker("",
                       selection: isWhen == .dateThere ?
                       $model.dateThere: $model.dateBack,
                       in: Date.now...,
                       displayedComponents: [.date])
            .datePickerStyle(.graphical)
            Spacer()
        }
        .foregroundColor(.black)
        .padding()
        .onDisappear{
            if isWhen == .dateThere && model.dateBack < model.dateThere {
                model.dateBack = model.dateThere
            } else if isWhen == .dateBack && model.dateThere > model.dateBack {
                model.dateThere = model.dateBack
            }
        }
    }
}

struct DatePick_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        DatePick(isWhen: .dateThere)
            .environmentObject(model)
    }
}
