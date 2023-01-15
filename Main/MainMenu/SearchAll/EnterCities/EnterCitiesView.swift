//
//  EnterCitiesView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 02.01.2023.
//

import SwiftUI

struct EnterCitiesView: View {
    @EnvironmentObject var model: MainModel
    
    @State private var isWhere: IsPlace?
    @State private var changeCity = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Button {
                    isWhere = .departure
                } label: {
                    HStack {
                        Text(model.departure?.name ?? "Введите место отправления")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                        Spacer()
                    }
                }
                Divider()
                Button {
                    isWhere = .arrival
                } label: {
                    HStack {
                        Text(model.arrival?.name ?? "Введите место прибытия")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .foregroundColor(.white)
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
            if isWhere == .departure {
                SearchCityView(isWhere: isWhere)
            } else if isWhere == .arrival {
                SearchCityView(isWhere: isWhere)
            }
        }
    }
}

extension EnterCitiesView {
    enum IsPlace: Identifiable {
        case departure
        case arrival
        
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
