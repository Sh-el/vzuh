//
//  HelpView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 29.12.2022.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        ZStack {
            Image("day_snow")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
        }
                .tabItem{
                    Image(systemName: "ellipsis.message.fill")
                    Text("Заказы")
                }
        
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
