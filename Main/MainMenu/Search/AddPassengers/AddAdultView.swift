//
//  AddAdultView1.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 26.01.2023.
//

import SwiftUI

struct AddAdultView: View {
    @EnvironmentObject var model: MainVM

    var body: some View {
        Stepper {
            HStack {
                VStack(alignment: .leading) {
                    Text("Взрослые")
                    Text("от 12 лет")
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("\(model.passengers.filter {$0 == .adult}.count)")
                    .padding(.horizontal, 20)
            }
        } onIncrement: {
            model.inputPassengersForAction = (model.passengers, .addAdult)
            model.passengers1.send(model.passengers)
        } onDecrement: {
            model.inputPassengersForAction = (model.passengers, .removeAdult)
        }
    }
}

struct AddAdultView1_Previews: PreviewProvider {
    static let model = MainVM()
    static var previews: some View {
        AddAdultView()
            .environmentObject(model)
    }
}
