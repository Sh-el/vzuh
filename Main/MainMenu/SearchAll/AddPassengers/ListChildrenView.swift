//
//  ListChildrenView2.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 05.01.2023.
//

import SwiftUI

struct ListChildrenView: View {
    @EnvironmentObject var model: MainModel
    
    var body: some View {
        if !model.children.isEmpty {
            VStack{
                Text("\(model.children.count)")
                ForEach(model.children, id: \.id) {child in
                    HStack {
                        Text(child.age.description)
                        Spacer()
                        Button {
                            model.removeChild(child)
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

struct ListChildrenView2_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        ListChildrenView()
            .environmentObject(model)
    }
}


