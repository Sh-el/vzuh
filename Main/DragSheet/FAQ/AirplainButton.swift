//
//  FAQAirplainButton.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 29.12.2022.
//

import SwiftUI

struct AirplainButton: View {
    var body: some View {
        ButtonTop(image: "airplane", text: "Авиабилеты")
    }
}

struct FAQAirplainButton_Previews: PreviewProvider {
    static var previews: some View {
        AirplainButton()
    }
}
