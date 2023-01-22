//
//  EnterCitiesView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 02.01.2023.
//

import SwiftUI

struct EnterCitiesView: View {
    @EnvironmentObject var model: MainModel
    
    @State private var place: Place?
//    @State private var changeCity = false
    let selectedTab: ButtonsMain
    
    var body: some View {
        VStack {
            if selectedTab == .hotels {
                VStack {
                    HStack {
                        Text("1")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .foregroundColor(.clear)
                            .autocapitalization(.none)
                        Spacer()
                        
                    }
                    Divider()
                    Button {
                        place = .arrival
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
            }
            else {
                HStack {
                    VStack(alignment: .leading) {
                        Button {
                            place = .departure
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
                            place = .arrival
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
                            model.changeCity()
                        }
                        
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .padding()
                    }
                }
            }
        }
        .sheet(item: $place) {SearchCityView(place: $0)}
    }
}

extension EnterCitiesView {
    enum Place: Identifiable {
        case departure
        case arrival
        
        var id: Self{self}
    }
}

struct EnterCitiesView_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        EnterCitiesView(selectedTab: .all)
            .environmentObject(model)
    }
}
