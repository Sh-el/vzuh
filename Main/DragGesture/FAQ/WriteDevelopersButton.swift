//
//  WriteDevelopersButton.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 29.12.2022.
//

import SwiftUI

struct WriteDevelopersButton: View {
    @State private var isMoreDetail = false
    
    var body: some View {
        ButtonBottom(image: "wrench.and.screwdriver",
                        textHeader: "Написать разработчикам",
                        text: "Поделитесь своим мнением")
        .onTapGesture {
            isMoreDetail.toggle()
        }
        .sheet(isPresented: $isMoreDetail) {
            Text("More detail")
        }
    }
}

struct WriteDevelopersButton_Previews: PreviewProvider {
    static var previews: some View {
        WriteDevelopersButton()
    }
}
