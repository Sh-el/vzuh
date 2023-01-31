//
//  SignUpView1.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 28.12.2022.
//

import SwiftUI

struct PromoView: View {
    @State private var isMoreDetail = false
    @State private var isFullSize = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("2000 р за фото или видео")
                Spacer()
                Button {
                    withAnimation(.linear(duration: 0.5)) {
                        isFullSize.toggle()
                    }
                } label: {
                    Text(!isFullSize ? "v" : "^")
                }
            }
            .font(.title2)
            .bold()
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 20)

            if isFullSize {
                Text("""
                 Забронируйте отель на Вжух, снимите фото или видеоотзыв и загрузите на страницу отеля, чтобы получить промокод на 2000 р на следующее бронирование.
                 """)
                .padding(.horizontal, 10)
                .font(.headline)
                .lineLimit(4)
                .padding(.bottom, 10)

                Button {
                    isMoreDetail.toggle()
                } label: {
                    Text("Подробнее")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(.white)
                .cornerRadius(5)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .background(.green.opacity(0.5))
        .cornerRadius(20)
        .padding(.horizontal, 10)
        .sheet(isPresented: $isMoreDetail) {
            Text("More detail")
        }
    }
}

struct SignUpView1_Previews: PreviewProvider {
    static var previews: some View {
        PromoView()
    }
}
