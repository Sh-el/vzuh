//
//  FAQTrainButton.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 29.12.2022.
//

import SwiftUI

struct TrainButton: View {
    var body: some View {
        ButtonTop(image: "tram", text: "Поезда")
    }
}

struct FAQTrainButton_Previews: PreviewProvider {
    static var previews: some View {
        TrainButton()
    }
}
