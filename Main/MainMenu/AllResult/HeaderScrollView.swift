//
//  HeaderScrollView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 19.01.2023.
//

import SwiftUI

struct HeaderScrollView: View {
    @EnvironmentObject var mainVM: MainVM
    @Binding var showingOptions: Bool
    let scheduleCount: Int

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    showingOptions = true
                } label: {
                    HStack {
                        Text("\(scheduleCount) " + trainPlural(scheduleCount) + ",")
                            .foregroundColor(.black)
                        Text(mainVM.choiceSortTrainSchedules?.description ?? "Сортировка")
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

    func trainPlural(_ count: Int) -> String {
        switch count % 10 {
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
    static let mainVM = MainVM()
    static var previews: some View {
        HeaderScrollView(showingOptions: .constant(true), scheduleCount: 1)
            .environmentObject(mainVM)
    }
}
