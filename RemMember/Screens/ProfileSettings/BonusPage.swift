//
//  BonusPage.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase

struct BonusPage : View {
    @StateObject var userData = UserView()
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
            HStack {
                HStack(spacing: 10){
                    Text("\(userData.users.user_bonuses ?? 0)")
                        .font(.system(size: 54))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("бонусов")
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                }
                Spacer()
            }.padding()
            
            Header(title: "Как заработать?", color: Color.black.opacity(0.3))
                .padding()
            HStack {
                VStack(alignment: .leading, spacing: 10){
                    Text("5% от стоимости заказа")
                        .fontWeight(.medium)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    Text("10% от стоимости акксессуаров")
                        .fontWeight(.medium)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                }
                Spacer()
            }.padding()
            
            VStack{
                
                VStack(alignment: .leading,spacing: 10){
                    
                    HStack {
                        Text("2NOMTA")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(Color("blue"))
                    }
                    
                    Text("Ваш промокод на 1000 бонусов")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                    
                    Text("Бонусы получите вы и друг при заказе от 5000₽")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .fontWeight(.regular)
                    Button(action: {
                        
                    }){
                        HStack {
                            Text("Поделиться")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(Color("blue"))
                            Image("share")
                        }
                            
                    }
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width - 30, alignment: .leading)
                .background(Color("blue_thin"))
                .cornerRadius(15)
//                        Spacer()
            }
            .padding([.horizontal,.bottom])
            Spacer()
        }.preferredColorScheme(.light)
        .onAppear{
            self.userData.fetchOrderHistory(client_id: Auth.auth().currentUser!.uid)
            self.userData.fetchAndMap()
        }
    }
}


struct BonusPage_Previews: PreviewProvider {
    static var previews: some View {
        HistoryTest()
    }
}


struct HistoryTest : View {
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("улица Тимура Фрунзе, 11с8")
                    .foregroundColor(.black.opacity(0.5))
                    .font(.system(size: 14))
                Spacer()
                Text("Завершен")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .foregroundColor(Color("blue"))
            }.padding()
            HStack {
                Text("#11 на 32900")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                Spacer()
            }.padding()
            VStack(spacing: 25) {
                VStack {
                    HStack {
                        Text("Замена")
                            .fontWeight(.regular)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        Text("1000")
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                    Rectangle()
                        .fill(Color.black.opacity(0.2))
                        .frame(width: UIScreen.main.bounds.width - 90,height: 1)
                }
                VStack {
                    HStack {
                        Text("Замена")
                            .fontWeight(.regular)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        Text("1000")
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                    Rectangle()
                        .fill(Color.black.opacity(0.2))
                        .frame(width: UIScreen.main.bounds.width - 90,height: 1)
                }
            }
        }
        .padding()
        .padding(.bottom,25)
        .background(Color.white)
        .cornerRadius(25)
        .padding(.vertical)
        .padding(.bottom)
        .padding(.horizontal,25)
        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 5, y: 5)
    }
}

