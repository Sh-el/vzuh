//
//  AddPassengersView1.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 05.01.2023.
//

import SwiftUI

struct AddPassengersView: View {
    @EnvironmentObject var model: MainModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isAddChild = false
    
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
                addChildButtonView
                Spacer()
                doneButtonView
            }
            .foregroundColor(.black)
            .padding()
            .sheet(isPresented: $isAddChild) {
                AddChildView()
                    .presentationDetents([.fraction(0.3)])
            }
            
            if model.resultAddPassengers.error != .everythingOk {
                AddPassengersAlertView()
                
            }
        }
    }
}

extension AddPassengersView {
    var addChildButtonView: some View {
        Button {
            isAddChild = true
        } label: {
            Text("+ Добавить ребенка")
        }
        .foregroundColor(.blue)
        .disabled(model.resultAddPassengers.isMaxPassengers)
    }
}

extension AddPassengersView {
    var doneButtonView: some View {
        Button {
            dismiss()
        } label: {
            Text("Готово")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(Color.blue.opacity(0.8))
        .cornerRadius(5)
        .padding(.horizontal, 10)
    }
}

struct AddPassengersView1_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        AddPassengersView()
            .environmentObject(model)
    }
}
