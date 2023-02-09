//
//  MainView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 30.12.2022.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var mainVm: MainVM
    @State private var selectedTopButton: TopButtons?

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                backgroundMain
                mainMenuView
                topButtonsView
                DragSheetView(startingOffsetY: Constants.startingOffsetYDragGesture)
                    .ignoresSafeArea()
            }
            .sheet(item: $selectedTopButton) {topButton in
                topButtonSheetView(topButton: topButton)
            }
        }
        .tabItem {
            Image(systemName: "magnifyingglass")
            Text("Поиск")
        }
        .tag(1)
    }
}

extension MainTabView {
    @ViewBuilder
    private func topButtonSheetView(topButton: TopButtons) -> some View {
        switch topButton {
        case .changeBackground:
            ChangeBackgroundView()
        case .notifications:
            NotificationsView()
        }
    }
}

extension MainTabView {
    var topButtonsView: some View {
        HStack {
            Text("vzuh")
            Spacer()
            Button {
                selectedTopButton = .changeBackground
            } label: {
                Image(systemName: "camera")
            }
            .padding(.horizontal)
            Button {
                selectedTopButton = .notifications
            } label: {
                Image(systemName: "bell")
            }
        }
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .padding()
    }
}

extension MainTabView {
    var mainMenuView: some View {
        MainMenuView()
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
            .offset(y: Constants.offsetYMainMenu)
            .ignoresSafeArea()
    }
}

extension MainTabView {
    var backgroundMain: some View {
        Image(mainVm.backgroundMain)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
    }
}

extension MainTabView {
    enum TopButtons: Identifiable {
        case changeBackground
        case notifications

        var id: Self {self}
    }
}

extension MainTabView {
    struct Constants {
        static let gradient = LinearGradient(colors: [.blue.opacity(0.4),
                                                      .blue.opacity(0.8)],
                                             startPoint: .topLeading,
                                             endPoint: .bottomTrailing)
        static let startingOffsetYDragGesture = UIScreen.main.bounds.height * 0.75
        static let offsetYMainMenu = -UIScreen.main.bounds.height * (1 - 0.75)
    }
}

struct MainView_Previews: PreviewProvider {
    static let model = MainVM()
    static var previews: some View {
        MainTabView()
            .environmentObject(model)
    }
}
