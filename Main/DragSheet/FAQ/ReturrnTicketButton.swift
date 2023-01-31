//
//  FAQReturrnTicketButton.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 29.12.2022.
//

import SwiftUI

struct ReturrnTicketButton: View {
    @State private var isMoreDetail = false

    var body: some View {
        ButtonBottom(image: "arrow.triangle.2.circlepath",
                     textHeader: "Вернуть или обменять билет",
                     text: "Правила возврата и обмена")
        .onTapGesture {
            isMoreDetail.toggle()
        }
        .sheet(isPresented: $isMoreDetail) {
            Text("More detail")
        }
    }

}

struct FAQReturrnTicketButton_Previews: PreviewProvider {
    static var previews: some View {
        ReturrnTicketButton()
    }
}
