//
//  WhereCanGoButton.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 29.12.2022.
//

import SwiftUI

struct WhereCanGoButton: View {
    @State private var isMoreDetail = false
    
    var body: some View {
        ButtonBottom(image: "balloon.fill",
                        textHeader: "Куда можно поехать ",
                        text: "Страны и регионы, открытые для россиян")
        .onTapGesture {
            isMoreDetail.toggle()
        }
        .sheet(isPresented: $isMoreDetail) {
            Text("More detail")
        }
    }
}

struct WhereCanGoButton_Previews: PreviewProvider {
    static var previews: some View {
        WhereCanGoButton()
    }
}
