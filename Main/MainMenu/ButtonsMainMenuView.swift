//
//  ButtonsMainView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 30.12.2022.
//

import SwiftUI

struct ButtonsMainMenuView: View {
    @EnvironmentObject var model: MainModel
    @Binding var selectedTab: ButtonsMain
//    @State private var selected: Const.ButtonsMain = .all
    
    var body: some View {
        VStack {
            HStack {
                ForEach(model.buttonsMain, id: \.self) {value in
                    VStack {
                        Image(systemName: value.imageName)
                            .foregroundColor(value == selectedTab ?
                                             Const.colorDefault.opacity(Const.opacity) : Const.colorSelcted)
                            .padding(10)
                            .background {
                                Circle()
                                    .foregroundColor(value == selectedTab ? Const.colorSelcted : Const.colorDefault.opacity(Const.opacity))
                            }
                    }
                    .onTapGesture {
                        selectedTab = value
                    }
                }
                Spacer()
            }
            .font(.title2)
            .fontWeight(.bold)
            
            
//            HStack {
//                ForEach(Const.ButtonsMain.allCases, id: \.id) {value in
//                    VStack {
//                        Image(systemName: value.imageName)
//                            .foregroundColor(value == selected ?
//                                             Const.colorDefault.opacity(Const.opacity) : Const.colorSelcted)
//                            .padding(10)
//                            .background {
//                                Circle()
//                                    .foregroundColor(value == selected ? Const.colorSelcted : Const.colorDefault.opacity(Const.opacity))
//                            }
//                            .onTapGesture {
//                                selected = value
//                            }
//                    }
//                }
//                Spacer()
//            }
//            .font(.title2)
//            .fontWeight(.bold)
//            .padding()
        }
        
    }
    
    private struct Const {
        static let colorSelcted = Color.white
        static let colorDefault = Color.black
        static let opacity: CGFloat = 2/3
        
//        enum ButtonsMain: Identifiable, CaseIterable {
//            case all
//            case hotels
//            case airplane
//            case train
//            case bus
//
//            var imageName: String {
//                switch self {
//                case .all:
//                    return "globe"
//                case .hotels:
//                    return "bed.double"
//                case .airplane:
//                    return "airplane"
//                case .train:
//                    return "tram"
//                case .bus:
//                    return "bus"
//                }
//            }
//
//            var id: Self{self}
//        }
        
    }
}

struct ButtonsMainView_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        ButtonsMainMenuView(selectedTab: .constant(ButtonsMain.all))
            .environmentObject(model)
    }
}
