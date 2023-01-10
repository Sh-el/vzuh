//
//  PassengersView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 02.01.2023.
//

import SwiftUI

struct PassengersView: View {
    @EnvironmentObject var model: MainModel
    
    @State private var isPassengersChoice = false
    
    var body: some View {
        HStack {
            Text(model.adultPassengers == 1 ? "\(model.adultPassengers) пассажир" : "\(model.adultPassengers) пассажира")
        }
        .onTapGesture {
            isPassengersChoice.toggle()
        }
        .sheet(isPresented: $isPassengersChoice) {
            AddPassengersView()
            .presentationDetents([.fraction(0.35)])
        }
    }
}

struct PassengersView_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        PassengersView()
            .environmentObject(model)
    }
}
