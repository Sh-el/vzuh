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
            VStack {
                Text("You can use gradients as the TabView's background color.")
                    .padding()
                    .frame(maxHeight: .infinity)
                
                
            }
            .font(.title2)
        }
        .tabItem{
            Image(systemName: "ellipsis.message.fill")
            Text("Help")
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
