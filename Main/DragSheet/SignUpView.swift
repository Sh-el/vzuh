//
//  SignUpView.swift
//  vzuh
//
//  Created by Stanislav Shelipov on 28.12.2022.
//

import SwiftUI

struct SignUpView: View {
    @State private var isEnter = false
    
    var body: some View {
        VStack() {
            HStack {
                Text("Привет")
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(1)
                Spacer()
            }
            .padding(.top, 15)
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person.circle")
                        .font(.largeTitle)
                    
                    Text("Войти в свой профиль")
                        .font(.title)
                        .bold()
                        .lineLimit(2)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                }
                .padding(.horizontal, 10)
                
                Text("Проверьте заказы и сохраните данные пассажиров.")
                    .font(.headline)
                    .lineLimit(5)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                
                Button {
                    isEnter.toggle()
                } label: {
                    Text("Войти")
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(.blue.opacity(0.2))
                        .cornerRadius(5)
                }
                
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity)
            .background(.blue.opacity(0.1))
            .cornerRadius(20)
        }
        .padding(.horizontal, 10)
        .sheet(isPresented: $isEnter) {
            Text("Enter")
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
