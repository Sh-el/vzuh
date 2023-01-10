//
//  BusFindView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 30.12.2022.
//

import SwiftUI

struct BusFindView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Airplane")
            Divider()
            Text("Airplane")
            Divider()
            Text("Airplane")
            Divider()
            Text("Airplane")
            Divider()
        }
        .foregroundColor(.white)
        .padding()
    }
}

struct BusFindView_Previews: PreviewProvider {
    static var previews: some View {
        BusFindView()
    }
}
