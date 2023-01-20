//
//  RailwayCarriageCategoryView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 17.01.2023.
//

import SwiftUI

struct RailwayCarriageCategoryView: View {
    let trip: TrainSchedule.Trip
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(trip.categories, id: \.self) {category in
                    VStack(alignment: .leading) {
                        Text("от " +  String(category.price).addSpaceBeforLastTHreeSymbol + " \u{20BD}")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        Text(category.type.description)
                        
                    }
                    .padding(5)
                    .background(.blue.opacity(0.15))
                    .cornerRadius(5)
                }
            }
        }
    }
}

extension StringProtocol {
    var addSpaceBeforLastTHreeSymbol: String{prefix(self.count - 3) + " " + dropFirst(self.count - 3)}
}


//struct RailwayCarriageCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        RailwayCarriageCategoryView(trip: TrainSchedule.Trip())
//    }
//}
