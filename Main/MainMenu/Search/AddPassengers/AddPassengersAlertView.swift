//
//  AddPassengersAlertView1.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 26.01.2023.
//

import SwiftUI

struct AddPassengersAlertView: View {
    @EnvironmentObject var model: MainVM
  
    var body: some View {
        HStack {
            Text(model.actionPassengersResult.rawValue)
            Spacer()
            Button {
                    model.actionPassengersResult = .ok
            } label: {
                Text("X")
            }
        }
        .padding()
        .background(Color.yellow)
        .foregroundColor(.black)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                model.actionPassengersResult = .ok
            }
        }
    }
}

struct AddPassengersAlertView1_Previews: PreviewProvider {
    static let model = MainVM()
    static var previews: some View {
        AddPassengersAlertView()
            .environmentObject(model)
    }
}
