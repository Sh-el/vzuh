//
//  AddAdultView1.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 05.01.2023.
//

import SwiftUI

struct AddAdultView: View {
    @EnvironmentObject var model: MainModel
    
    var body: some View {
        Stepper {
            HStack {
                VStack(alignment: .leading) {
                    Text("Взрослые")
                    Text("от 12 лет")
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("\(model.adultPassengers)")
                    .padding(.horizontal, 20)
            }
        } onIncrement: {
            model.addAdult()
        } onDecrement: {
            model.removeAdult()
        }
    }
}

struct NumberAdultView1_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        AddAdultView()
            .environmentObject(model)
    }
}
