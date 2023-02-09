//
//  DatePick.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 01.01.2023.
//

import SwiftUI

struct DatePick: View {
    @EnvironmentObject var mainVM: MainVM
    let dateTrip: DateSelectionView.TripType?

    var body: some View {
        VStack {
            if dateTrip == .dateDeparture {
                Text((mainVM.departure?.name ?? "") + " - " + (mainVM.arrival?.name ?? ""))
                    .font(.largeTitle)
            } else {
                Text((mainVM.arrival?.name ?? "") + " - " + (mainVM.departure?.name ?? ""))
                    .font(.largeTitle)
            }
            DatePicker("",
                       selection: dateTrip == .dateDeparture ?
                       $mainVM.dateDeparture: $mainVM.dateBack,
                       in: Date.now...,
                       displayedComponents: [.date])
            .datePickerStyle(.graphical)
            Spacer()
        }
        .foregroundColor(.black)
        .padding()
        .onDisappear {
            if dateTrip == .dateDeparture && mainVM.dateBack < mainVM.dateDeparture {
                mainVM.dateBack = mainVM.dateDeparture
            } else if dateTrip == .dateReturn && mainVM.dateDeparture > mainVM.dateBack {
                mainVM.dateDeparture = mainVM.dateBack
            }
        }
    }
}

struct DatePick_Previews: PreviewProvider {
    static let mainVM = MainVM()
    static var previews: some View {
        DatePick(dateTrip: .dateDeparture)
            .environmentObject(mainVM)
    }
}
