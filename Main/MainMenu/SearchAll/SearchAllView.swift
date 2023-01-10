//
//  AllFindView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 30.12.2022.
//

import SwiftUI

struct SearchAllView: View {
    var body: some View {
        VStack(alignment: .leading) {
            EnterCitiesView()
            Divider()
            DateSelectionView()
            Divider()
            PassengersView()
            Divider()
        }
        .padding()
    }
}



struct AllFindView_Previews: PreviewProvider {
    static let model = MainModel()
    
    static var previews: some View {
        SearchAllView()
            .environmentObject(model)
    }
}
