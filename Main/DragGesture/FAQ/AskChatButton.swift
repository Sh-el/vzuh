//
//  FAQAskChatButton.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 29.12.2022.
//

import SwiftUI

struct AskChatButton: View {
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "ellipsis.message.fill")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding()
            Text("Спросить в чате")
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
                .padding(.horizontal, 5)
            Spacer()
        }
        .foregroundColor(.black)
        .frame(maxWidth: .infinity)
        .background(.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.blue.opacity(0.5), lineWidth: 0.5)
        )
        .padding(.bottom, 30)
    }
}

struct FAQAskChatButton_Previews: PreviewProvider {
    static var previews: some View {
        AskChatButton()
    }
}
