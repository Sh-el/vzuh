//
//  MainView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 30.12.2022.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var model: MainModel
    @State private var isTopButtons: TopButtons?
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundMain
                VStack(alignment: .leading) {
                    topButtons
                    Spacer()
                    MainMenuView()
//                    NavigationLink(destination: Text("Search")) {
//                        searchButton
//                    }
                }
                DragGestureMainView()
            }
            .sheet(item: $isTopButtons, content: {topButton in
                if topButton == .changeBackground {
                    ChangeBackgroundView()
                } else if topButton == .notifications {
                    NotificationsView()
                }
            })
        }
        .tabItem{
            Image(systemName: "magnifyingglass")
            Text("Search")
        }
        .tag(1)
    }
}

extension MainView {
    var topButtons: some View {
        HStack {
            Text("vzuh")
            Spacer()
            Button {
                isTopButtons = .changeBackground
                print("cb")
            } label: {
                Image(systemName: "camera")
            }
            .padding(.horizontal)
            Button {
                isTopButtons = .notifications
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

extension MainView {
    var searchButton: some View {
        Text("Найти")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Const.gradient)
            .cornerRadius(5)
            .padding(.horizontal, 10)
            .padding(.bottom, 90)
    }
}

extension MainView {
    var backgroundMain: some View {
        Image(model.backgroundMain)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
    }
}

extension MainView {
    struct Const {
        static let gradient = LinearGradient(colors: [.blue.opacity(0.4), .blue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

extension MainView {
    enum TopButtons: Identifiable {
        case changeBackground
        case notifications
        
        var id: Self{self}
    }
}

struct MainView_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        MainView()
            .environmentObject(model)
    }
}
