//
//  EnterCitiesView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 02.01.2023.
//

import SwiftUI

struct EnterCitiesView: View {
    enum IsWhere: Identifiable {
        case whereFrom
        case whereTo
        
        var id: Self{self}
    }
    
    @State private var isWhere: IsWhere?
    
    @EnvironmentObject var model: MainModel
    @State private var changeCity = false
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Button {
                    isWhere = .whereFrom
                } label: {
                    HStack {
                        Text(model.departure.stationName)
                            .autocapitalization(.none)
                        Spacer()
                    }
                }
                
                Divider()
                TextField("", text: $model.arrival.stationName)
                    .autocapitalization(.none)
                    .onTapGesture {
                        isWhere = .whereTo
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
        .sheet(item: $isWhere, content: {isWhere in
            if isWhere == .whereFrom {
                SearchCityView(isWhere: isWhere)
            } else if isWhere == .whereTo {
                SearchCityView(isWhere: isWhere)
            }
        })
    }
}

struct EnterCitiesView_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        EnterCitiesView()
            .environmentObject(model)
    }
}
