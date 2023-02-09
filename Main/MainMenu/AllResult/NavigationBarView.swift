//
//  NavigatiomBarView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 17.01.2023.
//

import SwiftUI

struct NavigationBarView: View {
    @EnvironmentObject var mainVM: MainVM
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
                    Text(mainVM.isDateBack ?
                         mainVM.dateDeparture.dateToString + " - " + mainVM.dateBack.dateToString :
                            mainVM.dateDeparture.dateToString + ".")
                    Text(mainVM.passengers.count == 1 ?
                         "\(mainVM.passengers.count) пассажир" :
                         "\(mainVM.passengers.count) пассажира")
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
    static let mainVM = MainVM()
    static var previews: some View {
        NavigationBarView()
            .environmentObject(mainVM)
    }
}
