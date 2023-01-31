//
//  AddChildView1.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 26.01.2023.
//

import SwiftUI

struct AddChildView: View {
    @EnvironmentObject var model: MainVM
    @State private var child: Passenger = Passenger.baby

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Text(child.description)

                Picker(selection: $child) {
                    Text(Passenger.baby.description).tag(Passenger.baby)
                    Text(Passenger.child.description).tag(Passenger.child)
                } label: {
                    Text("Select")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
//                .pickerStyle(WheelPickerStyle())

                Button {
                    if child == .baby {
                        model.inputPassengersForAction = (model.passengers, .addBaby)
                        dismiss()
                    } else {
                        model.inputPassengersForAction = (model.passengers, .addChild)
                        dismiss()
                    }

                    if  model.changeNumberPassengersError == .valid ||
                        model.changeNumberPassengersError == .lotsBabies {
                        dismiss()
                    }
                } label: {
                    Text("Ok")
                }
                .padding()
            }
            .foregroundColor(.black)
        }
    }
}

struct AddChildView1_Previews: PreviewProvider {
    static let model = MainVM()
    static var previews: some View {
        AddChildView()
            .environmentObject(model)
    }
}
