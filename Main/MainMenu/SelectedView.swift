//
//  SelectedView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 30.12.2022.
//

import SwiftUI

struct SelectedView: View {
//    @EnvironmentObject var model: ViewModel
    let selectedTab: ButtonsMain
    
    var body: some View {
        switch selectedTab {
        case .all:
            SearchAllView()
        case .hotels:
            HotelFindView()
        case .airplane:
            AirplaneFindView()
        case .train:
            TrainFindView()
        case .bus:
            BusFindView()
        }
    }
}

struct SelectedView_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        SelectedView(selectedTab: ButtonsMain.all)
            .environmentObject(model)
    }
}
