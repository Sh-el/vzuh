//
//  EnterCitiesView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 02.01.2023.
//

import SwiftUI

struct EnterCitiesView: View {
    @EnvironmentObject var model: MainModel
    
    @State private var isWhere: IsWhere?
    @State private var changeCity = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Button {
                    isWhere = .whereFrom
                } label: {
                    HStack {
                        Text(model.departure.stationName.isEmpty ? "Введите место отправления" : model.departure.stationName)
                            .foregroundColor(model.departure.stationName.isEmpty ? .gray.opacity(0.5) : .white)
                            .autocapitalization(.none)
                        Spacer()
                    }
                }
                Divider()
                Button {
                    isWhere = .whereTo
                } label: {
                    HStack {
                        Text(model.arrival.stationName.isEmpty ? "Введите место прибытия" : model.arrival.stationName)
                            .foregroundColor(model.arrival.stationName.isEmpty ? .gray.opacity(0.5) : .white)
                            .autocapitalization(.none)
                        Spacer()
                    }
                }
            }
            Button {
                withAnimation(.linear(duration: 0.3)) {
                    changeCity.toggle()
                    (model.arrival, model.departure) = (model.departure, model.arrival)
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .padding()
            }
        }
        .sheet(item: $isWhere) {isWhere in
            if isWhere == .whereFrom {
                SearchCityView(isWhere: isWhere)
            } else if isWhere == .whereTo {
                SearchCityView(isWhere: isWhere)
            }
        }
    }
}

extension EnterCitiesView {
    enum IsWhere: Identifiable {
        case whereFrom
        case whereTo
        
        var id: Self{self}
    }
}

struct EnterCitiesView_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        EnterCitiesView()
            .environmentObject(model)
    }
}
