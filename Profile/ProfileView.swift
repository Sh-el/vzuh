//
//  ProfileView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 29.12.2022.
//

import SwiftUI

struct ProfileView: View {
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
            Image(systemName: "person.circle")
            Text("Pofile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
