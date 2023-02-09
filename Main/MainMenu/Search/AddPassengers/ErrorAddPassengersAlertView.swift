//
//  AddPassengersAlertView1.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 26.01.2023.
//

import SwiftUI

struct ErrorAddPassengersAlertView: View {
    @EnvironmentObject var mainVM: MainVM

    var body: some View {
        HStack {
            Text(mainVM.changeNumberPassengersError.rawValue)
            Spacer()
            Button {
                mainVM.changeNumberPassengersError = .valid
            } label: {
                Image(systemName: "xmark")
            }
        }
        .padding()
        .background(Color.yellow)
        .foregroundColor(.black)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                mainVM.changeNumberPassengersError = .valid
            }
        }
    }
}

struct AddPassengersAlertView_Previews: PreviewProvider {
    static let mainVM = MainVM()
    static var previews: some View {
        ErrorAddPassengersAlertView()
            .environmentObject(mainVM)
    }
}
