//
//  DragGestureMain.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 28.12.2022.
//

import SwiftUI

struct DragGestureMainView: View {
    @State var startingOffsetY: CGFloat = UIScreen.main.bounds.height * 0.77
    @State var currentDragOffsetY: CGFloat = 0
    @State var endingOffsetY: CGFloat = 0
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 50, height: 5)
                .cornerRadius(20)
                .foregroundColor(.gray)
                .padding(.vertical, 10)
            ScrollView(showsIndicators: false) {
                VStack {
                    PromoView()
                    SignUpView()
                    FAQView()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(hue: 0.523, saturation: 0.109, brightness: 0.963))
        .cornerRadius(20)
        .offset(y: startingOffsetY)
        .offset(y: currentDragOffsetY)
        .offset(y: endingOffsetY)
        .gesture(gesture)
    }
}

extension DragGestureMainView {
    private var gesture: some Gesture {
        DragGesture()
            .onChanged {value in
                withAnimation(.spring()) {
                    currentDragOffsetY = value.translation.height
                }
            }
            .onEnded {value in
                withAnimation(.spring()) {
                    if currentDragOffsetY < -150 {
                        endingOffsetY = -startingOffsetY + 10
                    } else if endingOffsetY != 0 && currentDragOffsetY > 150 {
                        endingOffsetY = 0
                    }
                    currentDragOffsetY = 0
                }
            }
    }
}

struct DragGestureMain_Previews: PreviewProvider {
    static var previews: some View {
        DragGestureMainView()
    }
}
