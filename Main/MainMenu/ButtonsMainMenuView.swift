//
//  ButtonsMainView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 30.12.2022.
//

import SwiftUI

struct ButtonsMainMenuView: View {
    @EnvironmentObject var mainVM: MainVM

    var body: some View {
        VStack {
            HStack {
                ForEach(mainVM.buttonsMain, id: \.self) {button in
                    VStack {
                        Image(systemName: button.imageName)
                            .foregroundColor(button == mainVM.mainMenuTabSelected ?
                                             Constants.defaultColor.opacity(Constants.opacity) :
                                             Constants.selectedColor)
                            .padding(10)
                            .background {
                                Circle()
                                    .foregroundColor(button == mainVM.mainMenuTabSelected ?
                                                     Constants.selectedColor :
                                                     Constants.defaultColor.opacity(Constants.opacity))
                            }
                    }
                    .onTapGesture {
                        mainVM.mainMenuTabSelected = button
                    }
                }
                Spacer()
            }
            .font(.title2)
            .fontWeight(.bold)
        }
    }
}

extension ButtonsMainMenuView {
    private struct Constants {
        static let selectedColor = Color.white
        static let defaultColor = Color.black
        static let opacity: CGFloat = 0.7
    }
}

struct ButtonsMainView_Previews: PreviewProvider {
    static let mainVM = MainVM()
    static var previews: some View {
        ButtonsMainMenuView()
            .environmentObject(mainVM)
    }
}
