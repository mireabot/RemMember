//
//  UpdatePage.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.01.2022.
//

import Foundation
import SwiftUI


struct UpdatePage : View {
    @Environment(\.presentationMode) var present
    func Header(title: String,color: Color) -> HStack<TupleView<(Text, Spacer)>> {
        return // since both are same so were going to make it as reuable...
            HStack{
                
                Text(title)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black.opacity(0.3))
                
                Spacer()
            }
    }
    var body: some View {
        VStack {
            HStack{
                HStack(spacing: 10){
                    Button(action: {
                        self.present.wrappedValue.dismiss()
                    }) {
                        ZStack{
                            Circle()
                                .fill(Color.black.opacity(0.05))
                                .frame(width: 44,height: 46)
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            
            HStack {
                Image("logo")
                    .frame(width: 97, height: 89)
            }
            Header(title: "Что нового?", color: Color.black.opacity(0.3))
                .padding([.horizontal,.bottom])
                .padding(.top,10)
                .padding(5)
            
            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    Text("- Добавили верификацию телефона")
                        .fontWeight(.medium)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    Text("- Настроили push уведомления")
                        .fontWeight(.medium)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    Text("- Обновили историю заказов")
                        .fontWeight(.medium)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    Text("- Добавили этот раздел :)")
                        .fontWeight(.medium)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                }
                Spacer()
            }.padding()
            Spacer()
            Text("@Команда RemMember")
                .font(.system(size: 14))
                .foregroundColor(.black.opacity(0.4))
                .fontWeight(.regular)
                .padding(.bottom, 40)
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .preferredColorScheme(.light)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct UpdatePage_Previews: PreviewProvider {
    static var previews: some View {
        UpdatePage()
    }
}
