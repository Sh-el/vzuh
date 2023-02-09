//
//  DateSelectionView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 02.01.2023.
//

import SwiftUI

struct DateSelectionView: View {
    @EnvironmentObject var mainVM: MainVM
    @State private var selectedTrip: TripType?

    var body: some View {
        HStack {
            Text(mainVM.dateDeparture.dateToString)
                .fontWeight(.semibold)
                .onTapGesture {
                    selectedTrip = .dateDeparture
                }
            Spacer()
            Text(mainVM.isDateBack ? mainVM.dateBack.dateToString : "Обратно")
                .fontWeight(.semibold)
                .foregroundColor(mainVM.isDateBack ? .white : .gray.opacity(0.7))
                .onTapGesture {
                    selectedTrip = .dateReturn
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        mainVM.isDateBack = true
                    }
                }
            Spacer()
            if mainVM.isDateBack {
                Button {
                    mainVM.isDateBack = false
                } label: {
                    Image(systemName: "xmark")
                        .padding(.trailing, 20)
                }
            }
        }
        .sheet(item: $selectedTrip) {DatePick(dateTrip: $0)}
    }
}

extension Date {
    var dateToString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM, E"
        return formatter.string(from: self)
    }
}

extension DateSelectionView {
    enum TripType: Identifiable {
        case dateDeparture
        case dateReturn

        var id: Self {self}
    }
}

struct DateSelectionView_Previews: PreviewProvider {
    static let mainVM = MainVM()
    static var previews: some View {
        DateSelectionView()
            .environmentObject(mainVM)
    }
}
