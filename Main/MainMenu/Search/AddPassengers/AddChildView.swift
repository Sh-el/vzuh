//
//  AddChildView1.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 26.01.2023.
//

import SwiftUI

struct AddChildView: View {
    @EnvironmentObject var mainVM: MainVM
    @State private var selectedChild: Passenger = .baby

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Text(selectedChild.description)

                Picker(selection: $selectedChild) {
                    Text(Passenger.baby.description).tag(Passenger.baby)
                    Text(Passenger.child.description).tag(Passenger.child)
                } label: {
                    Text("")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Button {
                    if selectedChild == .baby {
                        mainVM.actionNumberPassengers = .addBaby
                        dismiss()
                    } else {
                        mainVM.actionNumberPassengers = .addChild
                        dismiss()
                    }

                    if  mainVM.changeNumberPassengersError == .valid ||
                            mainVM.changeNumberPassengersError == .lotsBabies {
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

struct AddChildView_Previews: PreviewProvider {
    static let mainVM = MainVM()
    static var previews: some View {
        AddChildView()
            .environmentObject(mainVM)
    }
}
