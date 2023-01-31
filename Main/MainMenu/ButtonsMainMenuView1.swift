//
//  ButtonsMainMenuView1.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 27.01.2023.
//

import SwiftUI

struct ButtonsMainMenuView1: View {
    @EnvironmentObject var model: MainVM

    var body: some View {
        VStack {
            HStack {
                ForEach(MainMenuTab1.allCases, id: \.self) {value in
                    VStack {
                        Image(systemName: value.imageName)
                            .foregroundColor(value == model.mainMenuTabSelected1 ?
                                             Const.colorDefault.opacity(Const.opacity) : Const.colorSelcted)
                            .padding(10)
                            .background {
                                Circle()
                                    .foregroundColor(value == model.mainMenuTabSelected1 ?
                                                     Const.colorSelcted :
                                                     Const.colorDefault
                                                          .opacity(Const.opacity))
                            }
                    }
                    .onTapGesture {
                        model.mainMenuTabSelected1 = value
                    }
                }
                Spacer()
            }
            .font(.title2)
            .fontWeight(.bold)
        }
    }
}

extension ButtonsMainMenuView1 {
    private struct Const {
        static let colorSelcted = Color.white
        static let colorDefault = Color.black
        static let opacity: CGFloat = 0.7
    }
}

struct ButtonsMainMenuView1_Previews: PreviewProvider {
    static let model = MainVM()
    static var previews: some View {
        ButtonsMainMenuView1()
            .environmentObject(model)
    }
}
