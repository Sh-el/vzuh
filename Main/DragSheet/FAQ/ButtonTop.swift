//
//  FAQButton.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 29.12.2022.
//

import SwiftUI

struct ButtonTop: View {
    
    let image: String
    let text: String
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: image)
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding()
            Spacer()
            Text(text)
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
                .padding()
        }
        .foregroundColor(.black)
        .frame(maxWidth: .infinity)
        .frame(height: 130)
        .background(.blue.opacity(0.1))
        .cornerRadius(20)
    }
}

struct FAQButton_Previews: PreviewProvider {
    static var previews: some View {
        ButtonTop(image: "bus", text: "Text")
    }
}
