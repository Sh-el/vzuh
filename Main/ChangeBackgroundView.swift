//
//  ChangeBackgroundView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 06.01.2023.
//

import SwiftUI

struct ChangeBackgroundView: View {
    @EnvironmentObject var mainVM: MainVM
    @Environment(\.dismiss) private var dismiss

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 150, maximum: 250)),
         GridItem(.adaptive(minimum: 150, maximum: 250))]
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(mainVM.imagesBackground, id: \.self) {image in
                        Image(image)
                            .resizable()
                            .frame(height: 300)
                            .scaledToFit()
                            .cornerRadius(10)
                            .onTapGesture {
                                mainVM.backgroundMain = image
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
                    Image(systemName: "xmark")
                }
            }
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding()
        }
        .background(Image(mainVM.backgroundMain).blur(radius: 10))
        .padding(.horizontal, 5)
    }
}

struct ChangeBackgroundView_Previews: PreviewProvider {
    static let mainVM = MainVM()
    static var previews: some View {
        ChangeBackgroundView()
            .environmentObject(mainVM)
    }
}
