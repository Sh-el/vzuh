//
//  DateSelectionView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 02.01.2023.
//

import SwiftUI

struct DateSelectionView: View {
    @EnvironmentObject var model: MainVM
    @State private var dateTrip: DateTrip?

    var body: some View {
        HStack {
            Text(model.dateDeparture.dateToString)
                .fontWeight(.semibold)
                .onTapGesture {
                    dateTrip = .dateDeparture
                }
            Spacer()
            Text(model.isDateBack ? model.dateBack.dateToString : "Обратно")
                .fontWeight(.semibold)
                .foregroundColor(model.isDateBack ? .white : .gray.opacity(0.7))
                .onTapGesture {
                    dateTrip = .dateBack
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        model.isDateBack = true
                    }
                }
            Spacer()
            if model.isDateBack {
                Button {
                    model.isDateBack = false
                } label: {
                    Text("X")
                        .padding(.trailing, 20)
                }
            }
        }
        .sheet(item: $dateTrip) {DatePick(dateTrip: $0)}
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
    enum DateTrip: Identifiable {
        case dateDeparture
        case dateBack

        var id: Self {self}
    }
}

struct DateSelectionView_Previews: PreviewProvider {
    static let model = MainVM()
    static var previews: some View {
        DateSelectionView()
            .environmentObject(model)
    }
}
