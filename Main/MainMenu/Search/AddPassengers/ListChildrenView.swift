//
//  ListChildrenView1.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 26.01.2023.
//

import SwiftUI

struct ListChildrenView: View {
    @EnvironmentObject var mainVM: MainVM

    var body: some View {
        let children = mainVM.passengers.filter({$0 == .child || $0 == .baby})
        if !children.isEmpty {
            VStack {
                ForEach(children, id: \.self) {child in
                    HStack {
                        Text(child.description)
                        Spacer()
                        Button {
                            mainVM.actionNumberPassengers = child == .child ? .removeChild : .removeBaby
                        } label: {
                            Image(systemName: "xmark")
                                .padding(.trailing, 20)
                        }
                    }
                }
            }
        }
    }
}

struct ListChildrenView_Previews: PreviewProvider {
    static let mainVM = MainVM()
    static var previews: some View {
        ListChildrenView()
            .environmentObject(mainVM)
    }
}
