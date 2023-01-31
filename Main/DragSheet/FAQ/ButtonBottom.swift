//
//  FAQButtonBottom.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 29.12.2022.
//

import SwiftUI

struct ButtonBottom: View {
    let image: String
    let textHeader: String
    let text: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: image)
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding(.leading, 10)
                    .padding(.top, 10)
                Spacer()
            }
            Text(textHeader)
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(2)
                .padding(.leading, 10)
            Text(text)
                .font(.callout)
                .foregroundColor(.gray)
                .padding(.leading, 10)
            Spacer()

        }
        .foregroundColor(.black)
        .frame(height: 150)
        .background(.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.blue.opacity(0.5), lineWidth: 0.5)
        )
    }
}

struct FAQButtonBottom_Previews: PreviewProvider {
    static var previews: some View {
        ButtonBottom(image: "bus", textHeader: "Hi", text: "Ok")
    }
}
