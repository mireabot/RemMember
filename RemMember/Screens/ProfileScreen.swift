//
//  ProfileScreen.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase
import BottomSheet

struct ProfileScreen : View {
    @State var settingsOpen = false
    @State var order = false
    @State var name = " "
    @State var showOrder = false
    @State var showHistory = false
    @State var phonenumber = " "
    @State var showFAQ = false
    @State var showEdit = false
    @State var showOnboard = false
    @State var showHelp = false
    @State var showBonus = false
    @StateObject var orderData = OrderTestModel()
    @StateObject var userData = UserView()
    @AppStorage("orderCreated") var status = false
    @State var userID = UserDefaults.standard.string(forKey: "UserID")
    @State var isSmallDevice = UIScreen.main.bounds.height < 750
    func Header(title: String,color: Color) -> HStack<TupleView<(Text, Spacer)>> {
        return // since both are same so were going to make it as reuable...
            HStack{
                
                Text(title)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Spacer()
            }
    }
    var body: some View {
        ZStack {
            Color.gray.opacity(0.04).edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack{
                    
                    HStack{
                        Text("Профиль")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                        
                        NavigationLink(destination: SettingsScreen()) {
                            ZStack{
                                Circle()
                                    .fill(Color.black.opacity(0.05))
                                    .frame(width: 44,height: 46)
                                Image("gear")
                                    .frame(width: 24, height: 24)
                            }
                        }
//                        .fullScreenCover(isPresented: $settingsOpen, content: {
//                            SettingsScreen()
//                        })
                    }
                    
                    
                }
                .padding([.horizontal,.bottom])
                .padding(.top,10)
                
                HStack {
                    HStack(spacing: 10){
                        VStack(alignment: .leading,spacing: 5){
                            Text(name)
                                .font(.system(size: 40))
                                .fontWeight(.bold)
                            Text(phonenumber)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                        }.padding()
                    }
                    Spacer()
                }.padding(5)
                if orderData.book.status != "Завершен" && orderData.book.status != "Отменен" && orderData.book.order_number != 0  {
                    HStack(alignment: .top) {
                        
                        HStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text("Заказ #\(orderData.book.order_number ?? 0)")
                                    .font(isSmallDevice ? .title : .title)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                
                                Text(orderData.book.status ?? "")
                                    .font(isSmallDevice ? .caption : .none)
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color.black.opacity(0.6))
                            }
                            .padding(.top,30)
                            .padding(.leading)
                            Spacer()
                        }
                        
                    }
                    .padding()
                    .background(
                        Color ("blue")
                            .cornerRadius(12)
                            .frame(width: UIScreen.main.bounds.width - 40,height: 100)
                            .padding(.top,30)
                    )
                    .padding(.top)
                    .onTapGesture {
                        self.order.toggle()
                    }
                    .sheet(isPresented: $order){
                        OrderScreen()
                    }
                }
                else {
                    
                }
                Spacer()
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 15){
                        NavigationLink(destination: BonusPage()){
                            HStack {
                                Text("Бонусы")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                ZStack {
                                    Rectangle()
                                        .fill(Color("black_light"))
                                        .frame(width: 60,height: 30)
                                        .cornerRadius(5)
                                    Text("\(userData.users.user_bonuses ?? 0)")
                                        .font(.system(size: 16))
                                        .fontWeight(.medium)
                                        .foregroundColor(.black)
                                }
                            }
                        }
//                        .fullScreenCover(isPresented: $showBonus, content: {
//                            BonusPage()
//                        })
                        Button(action: {
                            self.showHistory.toggle()
                        }){
                            HStack {
                                Text("Заказы")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                ZStack {
                                    Rectangle()
                                        .fill(Color("black_light"))
                                        .frame(width: 60,height: 30)
                                        .cornerRadius(5)
                                    Text("\(userData.users.user_orders ?? 0)")
                                        .font(.system(size: 16))
                                        .fontWeight(.medium)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .sheet(isPresented: $showHistory, content: {
                            OrderHistoryPage()
                        })
                        Button(action: {
                            self.showFAQ.toggle()
                        }){
                            Text("FAQ")
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                        }
                        .sheet(isPresented: $showFAQ, content: {
                            FAQ()
                        })
                        Button(action: {
                            self.showHelp.toggle()
                        }){
                            Text("Помощь")
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                        }
                        .sheet(isPresented: $showHelp){
                            HelpPage()
                        }
                    }
                    Spacer(minLength: 5)
                }
                .padding(15)
                Spacer()
                
            }
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear{
            self.userData.fetchAndMap()
            userData.fetchOrderHistory(client_id: userID ?? "")
            orderData.fetchAndMap()
            guard let retrive1  = UserDefaults.standard.string(forKey: "ClientName") else { return }
            self.name = retrive1
            guard let retrive2  = UserDefaults.standard.string(forKey: "Clientnumber") else { return }
            self.phonenumber = retrive2
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}

