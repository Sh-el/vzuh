//
//  SearchAllResultView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.01.2023.
//

import SwiftUI

struct AllResultsView: View {
    @EnvironmentObject var model: MainVM
    @State private var isDetail = false
    @State private var showingOptions = false

    var body: some View {
        ZStack {
            Image(model.backgroundMain)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Spacer()
                ScrollView(.vertical) {
                    switch model.trainSchedules {
                    case .success(let schedule):
                        if !schedule.isEmpty {
                            HeaderScrollView(showingOptions: $showingOptions,
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
                            .actionSheet(isPresented: $showingOptions) {ActionSheet(
                                title: Text("Сортировка:"),
                                buttons: [
                                    .default(Text("сначала дешевые")) {
                                        model.sortTrainSchedules = .lowestPrice
                                    //    model.inputTrainScheduleForSort = (schedule, .lowestPrice)
                                    },
                                    .default(Text("сначала быстрые")) {
                                        model.sortTrainSchedules = .fastest
                                    //    model.inputTrainScheduleForSort = (schedule, .fastest)
                                    },
                                    .default(Text("сначала ранние")) {
                                        model.sortTrainSchedules = .earliest
                                     //   model.inputTrainScheduleForSort = (schedule, .earliest)
                                    },
                                    .default(Text("сначала поздние")) {
                                        model.sortTrainSchedules = .latest
                                     //   model.inputTrainScheduleForSort = (schedule, .latest)
                                    },
                                    .cancel(Text("Отмена")) {
                                    }
                                ]
                            )}
                        } else {
                            NoScheduleView()
                        }

                    case .none:
                        EmptyView()
                    case .some(.failure(let error)):
                        ErrorAllResultView(error: (error as? RequestError)!)
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
        .task {
            model.trainSchedules = nil
            model.isSearch = true
        }
        .onDisappear {
            model.isSearch = false
        }
    }
}

struct SearchAllResultView_Previews: PreviewProvider {
    static let model = MainVM()
    static var previews: some View {
        AllResultsView()
            .environmentObject(model)
    }
}
