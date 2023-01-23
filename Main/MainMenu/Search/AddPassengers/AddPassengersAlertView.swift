//
//  LotsPassengers.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 04.01.2023.
//

import SwiftUI

struct AddPassengersAlertView: View {
    @EnvironmentObject var model: MainModel
  
    var body: some View {
        HStack {
            Text(model.resultAddPassengers.error.rawValue)
            Spacer()
            Button {
                    model.resultAddPassengers.error = .everythingOk
            } label: {
                Text("X")
            }
        }
        .padding()
        .background(Color.yellow)
        .foregroundColor(.black)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                model.resultAddPassengers.error = .everythingOk
            }
        }
    }
}

struct LotsPassengers_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        AddPassengersAlertView()
            .environmentObject(model)
    }
}
