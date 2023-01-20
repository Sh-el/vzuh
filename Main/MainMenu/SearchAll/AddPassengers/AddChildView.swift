//
//  AddChildView3.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 05.01.2023.
//

import SwiftUI

struct AddChildView: View {
    @EnvironmentObject var model: MainModel
    @State private var child: Child = Child(age: .zero)
   
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Text(child.age.description)
                Picker(selection: $child.age) {
                    ForEach(Child.AgeChild.allCases) {age in
                        Text(age.description).tag(age)
                    }
                } label: {
                    Text("Text")
                }
                .pickerStyle(WheelPickerStyle())
                
                Button {
                    model.addChild(child)
                    if  model.resultAddPassengers.error == .everythingOk || model.resultAddPassengers.error == .lotsBabies
                    {
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

struct AddChildView3_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        AddChildView()
            .environmentObject(model)
    }
}
