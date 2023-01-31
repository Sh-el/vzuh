//
//  QRButton.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 29.12.2022.
//

import SwiftUI

struct QRButton: View {
    @State private var isMoreDetail = false

    var body: some View {
        ButtonBottom(image: "qrcode",
                     textHeader: "QR-коды и ограничения",
                     text: "Самое важное о поездках в пандемию")
        .onTapGesture {
            isMoreDetail.toggle()
        }
        .sheet(isPresented: $isMoreDetail) {
            Text("More detail")
        }
    }
}

struct QRButton_Previews: PreviewProvider {
    static var previews: some View {
        QRButton()
    }
}
