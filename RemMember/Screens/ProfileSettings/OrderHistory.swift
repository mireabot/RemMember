//
//  OrderHistory.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import Firebase
import SwiftUI


struct OrderHistoryPage : View {
    @StateObject var userData = UserView()
    var body: some View {
        VStack {
            HStack {
                Text("Заказы")
                    .fontWeight(.medium)
                    .font(.system(size: 24))
                    .foregroundColor(.black)
                Spacer()
            }.padding()
            if userData.history.count == 0 {
                Spacer()
                VStack {
                    Text("История пуста")
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                    Text("Здесь вы увидите историю ваших заказов")
                        .fontWeight(.medium)
                        .font(.system(size: 18))
                        .foregroundColor(.black.opacity(0.5))
                }
            }
//            else {
//                ScrollView(.vertical, showsIndicators: false){
//                    VStack(spacing: 10){
//                        ForEach(userData.history){ order in
//                            VStack(spacing: 10) {
//                                HStack {
//                                    Text(order.client_adress ?? "")
//                                        .foregroundColor(.black.opacity(0.5))
//                                        .font(.system(size: 14))
//                                    Spacer()
//                                    Text(order.status ?? "")
//                                        .font(.system(size: 16))
//                                        .fontWeight(.medium)
//                                        .foregroundColor(Color("blue"))
//                                }.padding()
//                                HStack {
//                                    Text("#\(order.order_number ?? 0) на \(order.total_cost ?? "")₽")
//                                        .fontWeight(.bold)
//                                        .font(.system(size: 18))
//                                        .foregroundColor(.black)
//                                    Spacer()
//                                }.padding()
//                                ForEach(order.order, id: \.self){ order in
//                                    VStack(spacing: 15){
//                                        HStack {
//                                            Text(order.item_name)
//                                                .font(.system(size: 16))
//                                                .foregroundColor(.black)
//                                            Spacer()
//                                            Text("\(String(order.item_cost)) ₽")
//                                                .font(.system(size: 16))
//                                                .fontWeight(.semibold)
//                                                .foregroundColor(.black)
//                                        }
//                                        Rectangle()
//                                            .fill(Color.gray.opacity(0.2))
//                                            .frame(width: UIScreen.main.bounds.width - 90, height: 1)
//                                    }
//                                }
//
//                            }
//                            .padding()
//                            .padding(.bottom,25)
//                            .background(Color.white)
//                            .cornerRadius(25)
//                            .padding(.vertical)
//                            .padding(.bottom)
//                            .padding(.horizontal,25)
//                            .shadow(color: Color.black.opacity(0.04), radius: 5, x: 5, y: 5)
//                        }
//                    }
//                }
//
//            }
            Spacer()
            
        }.onAppear{
            self.userData.fetchOrderHistory(client_id: Auth.auth().currentUser!.uid)
        }
    }
}


//if userData.history.count == 0 {
//    Spacer()
//    VStack {
//        Text("История пуста")
//            .fontWeight(.bold)
//            .font(.system(size: 24))
//            .foregroundColor(.black)
//        Text("Здесь вы увидите историю ваших заказов")
//            .fontWeight(.medium)
//            .font(.system(size: 18))
//            .foregroundColor(.black.opacity(0.5))
//    }
//}
//else {
//    Text("История пуста")
//        .fontWeight(.bold)
//        .font(.system(size: 24))
//        .foregroundColor(.black)
//}
