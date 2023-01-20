//
//  NotificationsView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 07.01.2023.
//

import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var model: MainModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                Text("Уведомления")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
                Image(systemName: "bell")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                Text("Пока ничего нового")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                Text("Предупредим об изменении рейсов и расскажем о выгодных предложениях")
                    .lineLimit(2)
                Spacer()
            }
            .foregroundColor(.white)
        }
        .background(Image(model.backgroundMain).blur(radius: 10))
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static let model = MainModel()
    static var previews: some View {
        NotificationsView()
            .environmentObject(model)
    }
}
