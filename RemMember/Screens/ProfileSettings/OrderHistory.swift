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
    @State var userID = UserDefaults.standard.string(forKey: "UserID")
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
            else {
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: 25){
                        ForEach(userData.history){ order in
                            OrderHistoryView(history: order)
                        }
                    }
                }

            }
            Spacer()
            
        }.onAppear{
            self.userData.fetchOrderHistory()
        }
    }
}


struct OrderHistoryView : View {
    var history : Orderhistory
    var body: some View {
        HStack(spacing: 10) {
            HStack {
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 56, height: 56)
                        .cornerRadius(10)
                    Circle()
                        .fill(history.status == "Отменен" ? Color.red : Color("blue"))
                        .frame(width: 24, height: 24)
                }
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(history.status ?? "")
                    .foregroundColor(.black)
                    .fontWeight(.medium)
                    .font(.system(size: 16))
                Text("Заказ #\(history.order_number ?? 0)")
                    .foregroundColor(.black.opacity(0.7))
                    .fontWeight(.regular)
                    .font(.system(size: 14))
                Text("\(history.order.count) услуги")
                    .foregroundColor(.black.opacity(0.7))
                    .fontWeight(.regular)
                    .font(.system(size: 14))
            }
            Spacer()
            Text(history.date.getFormattedDate(format: "dd.MM.yyyy"))
                .foregroundColor(.black.opacity(0.7))
                .fontWeight(.regular)
                .font(.system(size: 14))
        }
        .padding()
//        .padding(.bottom,25)
        .background(Color("history_bg"))
        .cornerRadius(25)
//            .padding(.vertical)
//            .padding(.bottom)
        .padding(.horizontal,20)
        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 5, y: 5)
    }
}
