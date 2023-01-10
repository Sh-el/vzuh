//
//  DateSelectionView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 02.01.2023.
//

import SwiftUI

struct DateSelectionView: View {
    @EnvironmentObject var model: MainModel
    @State private var isWhen: IsWhen?
    @State private var isDateBackShow = false
    
    var body: some View {
        HStack {
            Text(model.dateThere.dateToString)
                .onTapGesture {
                    isWhen = .dateThere
                }
            Spacer()
            Text(isDateBackShow ? model.dateBack.dateToString : "Back")
                .onTapGesture {
                    isWhen = .dateBack
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isDateBackShow = true
                    }
                }
            Spacer()
            if isDateBackShow {
                Button {
                    isDateBackShow = false
                } label: {
                    Text("X")
                        .padding(.trailing, 20)
                }
            }
        }
        .sheet(item: $isWhen) {DatePick(isWhen: $0)}
    }
}

extension Date {
    var dateToString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, E"
        return formatter.string(from: self)
    }
}

extension DateSelectionView {
    enum IsWhen: Identifiable {
        case dateThere
        case dateBack
        
        var id: Self{self}
    }
}

struct DateSelectionView_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        DateSelectionView()
            .environmentObject(model)
    }
}

