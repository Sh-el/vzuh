//
//  SearchAllResultView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.01.2023.
//

import SwiftUI

struct AllResultsView: View {
    @EnvironmentObject var model: MainModel
    @State private var isDetail = false
    @State private var showingOptions = false
    @State private var sort: TrainSchedule.Sort?
    
    var body: some View {
        ZStack {
            Image(model.backgroundMain)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Spacer()
                ScrollView(.vertical) {
                    switch model.trainSchedule {
                    case .success(let schedule):
                        HeaderScrollView(showingOptions: $showingOptions,
                                         sort: $sort,
                                         schedule: schedule)
                        .padding(.top, 10)
                        .padding(.horizontal, 10)
                        
                        ForEach(schedule, id: \.self) {trip in
                            VStack(alignment: .leading) {
                                TrainNameView(trip: trip)
                                    .padding(5)
                                DepArrView(trip: trip)
                                    .padding(.bottom, 5)
                                    .padding(.horizontal, 5)
                                RailwayCarriageCategoryView(trip: trip)
                                    .padding(.bottom, 5)
                                    .padding(.horizontal, 5)
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .background(.blue.opacity(0.1))
                            .cornerRadius(5)
                            .padding(.horizontal, 10)
                            .onTapGesture {
                                isDetail.toggle()
                            }
                        }
                    case .none:
                        EmptyView()
                    case .some(.failure(let error)):
                        ErrorAllResultView(error: error as! RequestError)
                            .padding(.top, 10)
                            .padding(.horizontal, 5)
                    }
                }
                .background(Color(hue: 0.523, saturation: 0.109, brightness: 0.963))
                .scrollContentBackground(.hidden)
                .padding(.top, 10)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: NavigatiomBarView())
            
        }
        .sheet(isPresented: $isDetail) {
            ZStack {
                Text("")
            }
        }
        .actionSheet(isPresented: $showingOptions) {sortActionSheet}
        .onAppear {
            model.trainSchedule = nil
            model.isSearch = true
            print("onappear")
        }
        .onDisappear{
            model.isSearch = false
            print("onDisappear")
        }
    }
}


extension AllResultsView {
    private var sortActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Сортировка:"),
            buttons: [
                .default(Text("сначала дешевые")) {
                    model.sortTrainSchedule(by: .lowestPrice)
                    sort = .lowestPrice
                },
                .default(Text("сначала быстрые")) {
                    model.sortTrainSchedule(by: .fastest)
                    sort = .fastest
                },
                .default(Text("сначала ранние")) {
                    model.sortTrainSchedule(by: .earliest)
                    sort = .earliest
                },
                .default(Text("сначала поздние")) {
                    model.sortTrainSchedule(by: .latest)
                    sort = .latest
                },
                .cancel(Text("Отмена")) {
                }
            ]
        )
    }
}


struct SearchAllResultView_Previews: PreviewProvider {
    static let model = MainModel()
    //    static let searching = SearchingCities()
    static var previews: some View {
        AllResultsView()
            .environmentObject(model)
        //            .environmentObject(searching)
    }
}
