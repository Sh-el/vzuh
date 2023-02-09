//
//  SearchAllResultView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 09.01.2023.
//

import SwiftUI

struct AllResultsView: View {
    @EnvironmentObject var mainVM: MainVM
    @State private var isDetail = false
    @State private var showingOptions = false

    var body: some View {
        ZStack {
            Image(mainVM.backgroundMain)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Spacer()
                ScrollView(.vertical) {
                    switch mainVM.trainSchedules {
                    case .success(let schedule):
                        if !schedule.isEmpty {
                            HeaderScrollView(showingOptions: $showingOptions,
                                             scheduleCount: schedule.count)
                            .padding(.top, 10)
                            .padding(.horizontal, 10)

                            ForEach(schedule, id: \.self) {trip in
                                VStack(alignment: .leading) {
                                    TrainNameView(trip: trip)
                                        .padding(5)
                                    TrainTimeView(trip: trip)
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
                                        mainVM.choiceSortTrainSchedules = .lowestPrice
                                    },
                                    .default(Text("сначала быстрые")) {
                                        mainVM.choiceSortTrainSchedules = .fastest
                                    },
                                    .default(Text("сначала ранние")) {
                                        mainVM.choiceSortTrainSchedules = .earliest
                                    },
                                    .default(Text("сначала поздние")) {
                                        mainVM.choiceSortTrainSchedules = .latest
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
                        if let error = error as? RequestError {
                            ErrorAllResultView(error: error)
                                .padding(.top, 10)
                                .padding(.horizontal, 5)
                        } else {
                            Text("unknown error")
                        }
                    }
                }
                .background(Color(hue: 0.523, saturation: 0.109, brightness: 0.963))
                .scrollContentBackground(.hidden)
                .padding(.top, 10)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: NavigationBarView())
        }
        .sheet(isPresented: $isDetail) {
            ZStack {
                Text("")
            }
        }
        .task {
            mainVM.trainSchedules = nil
            mainVM.isSearch = true
        }
        .onDisappear {
            mainVM.isSearch = false
        }
    }
}

struct SearchAllResultView_Previews: PreviewProvider {
    static let mainVM = MainVM()
    static var previews: some View {
        AllResultsView()
            .environmentObject(mainVM)
    }
}
