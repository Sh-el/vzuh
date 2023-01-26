//
//  ButtonsMainView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 30.12.2022.
//

import SwiftUI

struct ButtonsMainMenuView: View {
    @EnvironmentObject var model: MainModel
    
    var body: some View {
        VStack {
            HStack {
                ForEach(model.buttonsMain, id: \.self) {value in
                    VStack {
                        Image(systemName: value.imageName)
                            .foregroundColor(value == model.mainMenuTabSelected ?
                                             Const.colorDefault.opacity(Const.opacity) : Const.colorSelcted)
                            .padding(10)
                            .background {
                                Circle()
                                    .foregroundColor(value == model.mainMenuTabSelected ? Const.colorSelcted : Const.colorDefault.opacity(Const.opacity))
                            }
                    }
                    .onTapGesture {
                        model.mainMenuTabSelected = value
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
    private struct Const {
        static let colorSelcted = Color.white
        static let colorDefault = Color.black
        static let opacity: CGFloat = 0.7
    }
}

struct ButtonsMainView_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        ButtonsMainMenuView()
            .environmentObject(model)
    }
}
