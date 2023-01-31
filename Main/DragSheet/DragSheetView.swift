//
//  DragGestureMain.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 28.12.2022.
//

import SwiftUI

struct DragSheetView: View {
    @State var startingOffsetY: CGFloat
    @State private var currentDragOffsetY: CGFloat = 0
    @State private var endingOffsetY: CGFloat = 0
    @State private var isDisabled = true

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
                .padding(.bottom, 90)
            }
            .scrollDisabled(isDisabled)
        }
        .frame(maxWidth: .infinity)
        .background(Color(hue: 0.523, saturation: 0.109, brightness: 0.963))
        .cornerRadius(20)
        .offset(y: startingOffsetY)
        .offset(y: currentDragOffsetY)
        .offset(y: endingOffsetY)
        .gesture(gesture)
        .edgesIgnoringSafeArea(.bottom)
    }
}

extension DragSheetView {
    private var gesture1: some Gesture {
        DragGesture()
            .onChanged {value in
                withAnimation(.spring()) {
                    currentDragOffsetY = value.translation.height
                }
            }
            .onEnded {_ in
                withAnimation(.spring()) {
                    isDisabled = true
                }

            }
    }
}

extension DragSheetView {
    private var gesture: some Gesture {
        DragGesture()
            .onChanged {value in
                withAnimation(.spring()) {
                    currentDragOffsetY = value.translation.height
                }
            }
            .onEnded {_ in
                withAnimation(.spring()) {
                    if currentDragOffsetY < -150 {
                        endingOffsetY = -startingOffsetY + 40
                        isDisabled = false
                    } else if endingOffsetY != 0 && currentDragOffsetY > 150 {
                        endingOffsetY = 0
                        isDisabled = true
                    }
                    currentDragOffsetY = 0
                }
            }
    }
}

struct DragGestureMain_Previews: PreviewProvider {
    static var previews: some View {
        DragSheetView(startingOffsetY: 0)
    }
}
