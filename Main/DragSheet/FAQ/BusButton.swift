//
//  FAQBusButton.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 29.12.2022.
//

import SwiftUI

struct BusButton: View {
    var body: some View {
        ButtonTop(image: "bus", text: "Автобусы")
    }
}

struct FAQBusButton_Previews: PreviewProvider {
    static var previews: some View {
        BusButton()
    }
}
