//
//  ListChildrenView1.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 26.01.2023.
//

import SwiftUI

struct ListChildrenView: View {
    @EnvironmentObject var model: MainVM

    var body: some View {
        let children = model.passengers.filter({$0 == .child || $0 == .baby})
        if !children.isEmpty {
            VStack {
                ForEach(children, id: \.self) {child in
                    HStack {
                        Text(child.description)
                        Spacer()
                        Button {
                            if child == .child {
                                model.inputPassengersForAction = (model.passengers, .removeChild)
                            } else if child == .baby {
                                model.inputPassengersForAction = (model.passengers, .removeBaby)
                            }
                        } label: {
                            Text("X")
                                .padding(.trailing, 20)
                        }
                    }
                }
            }
        }
    }
}

struct ListChildrenView1_Previews: PreviewProvider {
    static let model = MainVM()
    static var previews: some View {
        ListChildrenView()
            .environmentObject(model)
    }
}
