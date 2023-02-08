//
//  FAQView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 29.12.2022.
//

import SwiftUI

struct FAQView: View {
    var body: some View {

            VStack {
                Text("Ответы на частые вопросы")
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .padding(.top, 15)

                HStack {
                    NavigationLink(
                        destination: HelpTabView()
                    ) {
                        AirplainButton()
                    }
                    NavigationLink(
                        destination: Text("TrainTickets")
                    ) {
                        TrainButton()
                    }
                    NavigationLink(
                        destination: Text("BusTickets")
                    ) {
                        BusButton()
                    }
                }

                HStack(spacing: 10) {
                    ReturrnTicketButton()
                    QRButton()
                }

                HStack(spacing: 10) {
                    WhereCanGoButton()
                    WriteDevelopersButton()
                }

                AskChatButton()
            }
            .padding(.horizontal, 10)
    }
}

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        FAQView()
    }
}
