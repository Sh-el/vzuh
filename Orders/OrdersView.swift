//
//  OrdersView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 29.12.2022.
//

import SwiftUI

struct OrdersView: View {
    var body: some View {
        ZStack {
            VStack {
                Text("You can use gradients as the TabView's background color.")
                    .padding()
                    .frame(maxHeight: .infinity)
                
               
            }
            .font(.title2)
        }
        .tabItem{
            Image(systemName: "dollarsign.square")
            Text("Orders")
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView()
    }
}
