//
//  PassengersView1.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 26.01.2023.
//

import SwiftUI

struct PassengersView: View {
    @EnvironmentObject var mainVM: MainVM
    @State private var isPassengersChoice = false

    var body: some View {
        Button {
            isPassengersChoice.toggle()
        } label: {
            HStack {
                Text(mainVM.passengers.count == 1 ?
                     "\(mainVM.passengers.count) пассажир" :
                     "\(mainVM.passengers.count) пассажира")
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
    static let mainVM = MainVM()
    static var previews: some View {
        PassengersView()
            .environmentObject(mainVM)
    }
}
