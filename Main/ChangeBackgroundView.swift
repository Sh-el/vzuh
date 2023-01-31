//
//  ChangeBackgroundView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 06.01.2023.
//

import SwiftUI

struct ChangeBackgroundView: View {
    @EnvironmentObject var model: MainVM
    @Environment(\.dismiss) private var dismiss

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 150, maximum: 250)),
         GridItem(.adaptive(minimum: 150, maximum: 250))]
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(model.imagesBackground, id: \.self) {image in
                        Image(image)
                            .resizable()
                            .frame(height: 300)
                            .scaledToFit()
                            .cornerRadius(10)
                            .onTapGesture {
                                model.backgroundMain = image
                                dismiss()
                            }
                    }
                }
                .padding(.vertical, 50)
            }
            HStack {
                Spacer()
                Text("Выбор обложки")
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("X")
                }
            }
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding()
        }
        .background(Image(model.backgroundMain).blur(radius: 10))
    }
}

struct ChangeBackgroundView_Previews: PreviewProvider {
    static let model = MainVM()
    static var previews: some View {
        ChangeBackgroundView()
            .environmentObject(model)
    }
}
