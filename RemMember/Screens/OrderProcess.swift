//
//  OrderProcess.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase


struct OrderScreen: View {
    @StateObject var viewModel = OrderTestModel()
    @StateObject var Homemodel = HomeViewModel()
    @AppStorage("orderCreated") var status = false
    @Environment(\.presentationMode) var present
    @State var userID = ""
    @State var confirm = false
    func Header(title: String,color: Color) -> HStack<TupleView<(Text, Spacer)>> {
        return // since both are same so were going to make it as reuable...
            HStack{
                
                Text(title)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Spacer()
            }
    }
    var body: some View {
        VStack {
            HStack {
                Text("Заказ #\(viewModel.book.order_number ?? 0)")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                Spacer()
                Text(viewModel.book.client_adress ?? "")
                    .foregroundColor(Color.black.opacity(0.3))
                    .font(.system(size: 14))
                    .fontWeight(.bold)
            }.padding()
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10){
                HStack{
                    VStack(alignment: .leading, spacing: 10){
                        HStack(spacing: 5){
                            Text(viewModel.book.status ?? "")
                                .foregroundColor(.black)
                                .font(.system(size: 28))
                                .fontWeight(.bold)
                            Image(viewModel.book.status ?? "Заказ оформлен")
                            
                        }
                        if viewModel.book.status == "Заказ оформлен"{
                            Text("Проверка займет 3-5 минут")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(Color.black.opacity(0.3))
                        }
                        if viewModel.book.status == "Заказ подтвержден"{
                            Text("Ищем свободного мастера для вас")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(Color.black.opacity(0.3))
                        }
                        if viewModel.book.status == "Мастер в пути" {
                            Text("К вам едет \(viewModel.book.order_master ?? "") \(viewModel.book.master_phone ?? "")")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(Color.black.opacity(0.3))
                        }
                        if viewModel.book.status == "Мастер у вас"{
                            Text("Ожидайте завершения ремонта")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(Color.black.opacity(0.3))
                        }
                    }
                    Spacer()
                }.padding()
                
                HStack(spacing: 15){
                    Rectangle()
                        .fill(viewModel.book.status == "Заказ оформлен" || viewModel.book.status == "Мастер в пути" || viewModel.book.status == "Заказ подтвержден" || viewModel.book.status == "Мастер у вас" ? Color("blue") : Color.black.opacity(0.08))
                        .frame(width: 80, height: 13)
                        .cornerRadius(5)
                    Rectangle()
                        .fill(viewModel.book.status == "Мастер в пути" || viewModel.book.status == "Мастер у вас" ? Color("blue") : Color.black.opacity(0.08))
                        .frame(width: 80, height: 13)
                        .cornerRadius(5)
                    Rectangle()
                        .fill(viewModel.book.status == "Мастер в пути" || viewModel.book.status == "Мастер у вас" ? Color("blue") : Color.black.opacity(0.08))
                        .frame(width: 80, height: 13)
                        .cornerRadius(5)
                    Rectangle()
                        .fill(viewModel.book.status == "Мастер у вас" ? Color("blue") : Color.black.opacity(0.08))
                        .frame(width: 80, height: 13)
                        .cornerRadius(5)
                }.padding()
            }
            Header(title: "Детали заказа", color: Color.black).padding()
            
            ForEach(viewModel.book.order, id: \.self){ order in
                VStack(spacing: 10){
                    HStack {
                        Text(order.item_name)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                        Text("\(String(order.item_cost)) ₽")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                    }.padding()
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: UIScreen.main.bounds.width - 20, height: 1)
                }
            }
            
            Spacer()
            
            Button(action: {
                self.confirm.toggle()
            }){
                ZStack{
                    Rectangle()
                        .fill(Color.red.opacity(0.8))
                        .frame(width: UIScreen.main.bounds.width - 60,height: 56)
                        .cornerRadius(12)
                        .shadow(color: Color.gray.opacity(0.04), radius: 1, x: 5, y: 5)
                        .shadow(color: Color.gray.opacity(0.04), radius: 1, x: -5, y: -5)
                    HStack(spacing: 2){
                        Text("Отменить заказ")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    }
                }
            }
        }
        .popup(isPresented: $confirm, type: .`default`, closeOnTap: true) {
            createPopup()
        }
        .preferredColorScheme(.light)
        .onAppear{
            viewModel.fetchAndMap()
            guard let retrive6  = UserDefaults.standard.string(forKey: "UserID") else { return }
            self.userID = retrive6
        }
        
    }
    func createPopup() -> some View {
        VStack(spacing: 35) {
            Text("Вы хотите отменить заказ?")
                .font(.system(size: 16))
                .fontWeight(.medium)
                .foregroundColor(.black)
            HStack {
                Button(action: {
                    self.confirm = false
                }){
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 100,height: 50)
                            .cornerRadius(10)
                        Text("Закрыть")
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                            .font(.system(size: 14))
                    }
                }
                Spacer()
                Button(action: {
                    self.Homemodel.cancelOrder(name: userID)
                    withAnimation{status = false}
                    self.confirm.toggle()
                    self.present.wrappedValue.dismiss()
                }){
                    ZStack {
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: 100,height: 50)
                            .cornerRadius(10)
                        Text("Отменить")
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                            .font(.system(size: 14))
                    }
                }
            }.padding()
        }
        .frame(width: UIScreen.main.bounds.width - 20, height: 165)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 5, y: 5)
    }
}

