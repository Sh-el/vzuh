//
//  AddAdultView1.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 26.01.2023.
//

import SwiftUI

struct AddAdultView: View {
    @EnvironmentObject var mainVM: MainVM

    var body: some View {
        Stepper {
            HStack {
                VStack(alignment: .leading) {
                    Text("Взрослые")
                    Text("от 12 лет")
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("\(mainVM.passengers.filter {$0 == .adult}.count)")
                    .padding(.horizontal, 20)
            }
        } onIncrement: {
            mainVM.actionNumberPassengers = .addAdult
        } onDecrement: {
            mainVM.actionNumberPassengers = .removeAdult
        }
    }
}

struct AddAdultView_Previews: PreviewProvider {
    static let mainVM = MainVM()
    static var previews: some View {
        AddAdultView()
            .environmentObject(mainVM)
    }
}
