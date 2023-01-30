//
//  PassengersView1.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 26.01.2023.
//

import SwiftUI

struct PassengersView: View {
    @EnvironmentObject var model: MainVM
    @State private var isPassengersChoice = false
    
    var body: some View {
        Button {
            isPassengersChoice.toggle()
        } label: {
            HStack {
                Text(model.passengers.count == 1 ? "\(model.passengers.count) пассажир" : "\(model.passengers.count) пассажира")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .sheet(isPresented: $isPassengersChoice) {
            AddPassengersView()
            .presentationDetents([.fraction(0.4)])
        }
    }
}

struct PassengersView1_Previews: PreviewProvider {
    static let model = MainVM()
    static var previews: some View {
        PassengersView()
            .environmentObject(model)
    }
}
