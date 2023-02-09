//
//  AddPassengersView1.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 26.01.2023.
//

import SwiftUI

struct AddPassengersView: View {
    @EnvironmentObject var mainVM: MainVM
    @Environment(\.dismiss) private var dismiss

    @State private var isAddChild = false
    @State private var isShow = false

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Text("Пассажиры")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                AddAdultView()
                Spacer()
                ListChildrenView()
                Spacer()
                addChildButton
                Spacer()
                doneButton
            }
            .foregroundColor(.black)
            .padding()
            .sheet(isPresented: $isAddChild) {
                AddChildView()
                    .presentationDetents([.fraction(0.3)])
            }
            if mainVM.changeNumberPassengersError != .valid {
                ErrorAddPassengersAlertView()
            }
        }
    }
}

extension AddPassengersView {
    var addChildButton: some View {
        Button {
         isAddChild = true
        } label: {
            Text("+ Добавить ребенка")
        }
        .foregroundColor(.blue)
        .disabled(mainVM.passengers.count == 4)
    }
}

extension AddPassengersView {
    var doneButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Готово")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(.blue)
                .cornerRadius(5)
                .padding(.horizontal, 10)
        }
    }
}

struct AddPassengersView_Previews: PreviewProvider {
    static let mainVM = MainVM()
    static var previews: some View {
        AddPassengersView()
            .environmentObject(mainVM)
    }
}
