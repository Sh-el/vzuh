//
//  NoScheduleView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 19.01.2023.
//

import SwiftUI

struct NoScheduleView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Нет сообщения по выбранному  маршруту")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            Text("Попробуйте выбрать другой вид транспорта или изменить место отправления или прибытия")
        }
        .foregroundColor(.black)
        .padding(5)
        .frame(maxWidth: .infinity)
        .background(.blue.opacity(0.1))
        .cornerRadius(5)
    }
}

struct NoScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        NoScheduleView()
    }
}
