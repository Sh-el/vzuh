//
//  HeaderScrollView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 19.01.2023.
//

import SwiftUI

struct HeaderScrollView: View {
    @EnvironmentObject var model: MainVM
    @Binding var showingOptions: Bool
    let schedule: [TrainTrip]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    showingOptions = true
                } label: {
                    HStack {
                        Text("\(schedule.count) " + trainOkonchanie(schedule.count) + ",")
                            .foregroundColor(.black)
                        Text(model.choiceSortTrainSchedules?.description ?? "Сортировка")
                            .foregroundColor(.blue)
                    }
                    .font(.headline)
                    .fontWeight(.heavy)
                }
            }
            HStack {
                Text("Время местное.")
                    .font(.callout)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
    }

    func trainOkonchanie(_ count: Int) -> String {
        guard let okonchanie = (String(count).last) else {return ""}
        guard let okInt = Int(String(okonchanie)) else {return ""}
        switch okInt {
        case 1:
            return "поезд"
        case 2...4:
            return "поезда"
        default:
            return"поездов"

        }
    }
}

struct HeaderScrollView_Previews: PreviewProvider {
    static let model = MainVM()
    static var previews: some View {
        HeaderScrollView(showingOptions: .constant(true), schedule: [TrainTrip]())
            .environmentObject(model)
    }
}
