//
//  TrainNameView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 19.01.2023.
//

import SwiftUI

struct TrainNameView: View {
    let trip: TrainTrip

    var body: some View {
        HStack {
            Text(trip.name?.trimmingCharacters(in: .whitespaces) ?? "")
            Text(trip.trainNumber.trimmingCharacters(in: .whitespaces))
        }
        .padding(5)
        .background(.blue.opacity(0.15))
        .cornerRadius(5)
    }
}

// struct TrainNameView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrainNameView(trip: TrainSchedule.Trip())
//    }
// }
