//
//  HomeScreen.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import PopupView
import Firebase
import BottomSheet

struct Home1 : View {
    @StateObject var chatData = ChatModelTest()
    @State var tab = 0
    @Namespace var animation
    @State var showCart = false
    @State var showAdress = false
    @State var showAccessories = false
    @State var showAlert = false
    @State var showAlertAdd = false
    @State var showTypes = false
    @StateObject var Homemodel = HomeViewModel()
    @State var showingPopup = false
    @State var orderCreated = false
    @StateObject var userData = UserView()
    @StateObject var clientModel = ClientInfo()
    @StateObject var orderData = OrderTestModel()
    @StateObject var settings = AppSettingsModel()
    @AppStorage("orderCreated") var status = false
    @AppStorage("trig") var trig = false
    @Environment(\.presentationMode) var present
    @State var userID = UserDefaults.standard.string(forKey: "UserID")
    var bottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom
    var white = Color.black
    func Header(title: String,color: Color) -> HStack<TupleView<(Text, Spacer)>> {
        return // since both are same so were going to make it as reuable...
            HStack{
                
                Text(title)
                    .font(.system(size: 28))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Spacer()
            }
    }
    @State var cart = 0
    var body: some View{
        
        ZStack{
            
            Color.gray.opacity(0.04).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                ZStack{
                    
                    HStack{
                        
                        Button(action: {
                            showAdress.toggle()
                        }) {
                            VStack(alignment: .leading, spacing: 2){
                                Text(userData.users.current_adress ?? "")
                                    .font(.system(size: 24))
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                                Text("Приедем в течение \(settings.app.delivery_time ?? "") минут")
                                    .foregroundColor(settings.app.delivery_time! != "30" ? .orange : .gray)
                            }
                        }.sheet(isPresented: $showAdress) {
                            Adresses()
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if Homemodel.cartItems.count == 0 && Homemodel.cartItemsAcc.count == 0 {
                                print("no items")
                                self.showingPopup.toggle()
                            }
                            else {
                                showCart.toggle()
                            }
                        }) {
                            
                            Image(systemName: "cart")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                        .fullScreenCover(isPresented: $showCart){
                            CartView(homeData: Homemodel)
                        }
                        .overlay(
                            
                            // Cart Count....
                            Text("\(Homemodel.cartItems.count + Homemodel.cartItemsAcc.count)")
                                .font(.caption)
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                                .frame(width: 20, height: 20)
                                .background(Color("blue"))
                                .clipShape(Circle())
                                .offset(x: 15, y: -22)
                                // disbling if no items...
                                .opacity(Homemodel.cartItems.count == 0 && Homemodel.cartItemsAcc.count == 0 ? 0 : 1)
                        )
                    }
                    
                    
                }
                .padding([.horizontal,.bottom])
                .padding(.top,10)
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack{
                        if Homemodel.events.isEmpty || Homemodel.events.capacity == 1 {
                            
                        }
                        else {
                            Header(title: "Акции", color: .black)
                                .padding()
                            
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack(spacing: 15){
                                    ForEach(Homemodel.events){event in
                                        
                                        //                                     Card View....
                                        NavigationLink(destination: EventDetailView(Homemodel: Homemodel, event: event)) {
                                            Event_View(event: event)
                                        }
                                    }
                                }
                                .padding()
                                .padding(.horizontal,4)
                            }
                        }
                        
                        Header(title: "Телефон", color: .black)
                            .padding()
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            VStack(spacing: 15){
                                
                                if Homemodel.items.isEmpty{
                                    
                                    VStack(spacing: 25){
                                        
                                        ProgressView()
                                    }
                                    .frame(width: UIScreen.main.bounds.width - 40, height: 150)
                                    .background(Color.white)
                                    .cornerRadius(25)
                                    .shadow(color: Color.gray.opacity(0.04), radius: 1, x: 5, y: 5)
                                    .shadow(color: Color.gray.opacity(0.04), radius: 1, x: -5, y: -5)
                                }
                                
                                else {
                                    ForEach(Homemodel.items){item in
                                        
                                        //                                     Card View....
                                        NavigationLink(destination: Detail(productModel: item, Homemodel: Homemodel)) {
                                            ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                                                ItemView(item: item)
                                                HStack(spacing: 10){
                                                    Button(action: {
//                                                        Homemodel.addToCart(item: item)
                                                        if orderData.book.active == true {
                                                            self.showAlert.toggle()
                                                        }
                                                        else {
                                                            self.Homemodel.cartItems.append(Cart(item: item, quantity: 1))
//                                                            if item.item_type == "Ремонт в офисе" {
//                                                                self.trig = true
//                                                                print("ok")
//                                                            }
                                                        }
                                                    }){
                                                        ZStack{
                                                            Rectangle()
                                                                .fill(Color("blue"))
                                                                .frame(width: 117,height: 43)
                                                                .cornerRadius(12)
                                                            HStack(spacing: 2){
                                                                Text(getPrice(value: Float(truncating: item.item_cost)))
                                                                    .fontWeight(.bold)
                                                                    .foregroundColor(.white)
                                                                Text("₽")
                                                                    .fontWeight(.bold)
                                                                    .foregroundColor(.white)
                                                            }
                                                        }
                                                    }
                                                    Text(item.item_plus_time)
                                                        .font(.system(size: 12))
                                                        .foregroundColor(Color.black.opacity(0.3))
                                                }
                                                .padding(.trailing, -60)
                                                .padding(.top,90)
                                            })
                                        }
                                        
                                    }
                                }
                            }
                            .padding()
                            .padding(.horizontal,4)
                        }
                        
                        ZStack {
                            Header(title: "Аксессуары", color: .black)
                                .padding()
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.showAccessories.toggle()
                                }) {
                                    Text("Смотреть все")
                                        .foregroundColor(Color("blue_light"))
                                }
                                .sheet(isPresented: $showAccessories){
                                    VStack {
                                        HStack(spacing: 25){
                                            
                                            Text("Аксессуары")
                                                .font(.system(size: 20))
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                            Spacer()
                                            
                                            
                                        }
                                        .padding()
                                        
                                        ScrollView(.vertical, showsIndicators: false) {
                                            
                                            VStack(spacing: 15){
                                                if Homemodel.accessories.isEmpty{
                                                    
                                                    HStack(spacing: 25){
                                                        
                                                        ProgressView()
                                                    }
                                                    .padding()
                                                    .frame(width: UIScreen.main.bounds.width - 30)
                                                    .background(Color.white)
                                                    .cornerRadius(25)
                                                    // shadows..
                                                    .shadow(color: Color.black.opacity(0.04), radius: 5, x: 5, y: 5)
                                                }
                                                else {
                                                    ForEach(Homemodel.accessories){item in
                                                        ZStack {
                                                            AccessoriesViewForAll(item: item)
                                                                
                                                            
                                                            HStack {
                                                                Spacer()
                                                                Button(action: {
                                                                    self.Homemodel.cartItemsAcc.append(CartAcc(accessori: item))
                                                                }) {
                                                                    Image(systemName: "plus")
                                                                        .font(.title2)
                                                                        .foregroundColor(.black)
                                                                }
                                                            }.padding()
                                                        }
                                                    }
                                                }
                                            }
                                            .padding()
                                            .padding(.horizontal,4)
                                        }
                                    }
                                }
                                
                            }.padding()
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 15){
                                
                                if Homemodel.accessories.isEmpty{
                                    
                                    HStack(spacing: 25){
                                        
                                        ProgressView()
                                    }
                                    .padding()
                                    .frame(width: UIScreen.main.bounds.width - 90, height: 117)
                                    .background(Color.white)
                                    .cornerRadius(25)
                                    // shadows..
                                    .shadow(color: Color.black.opacity(0.04), radius: 5, x: 5, y: 5)
                                }
                                
                                else {
                                    ForEach(Homemodel.accessories){item in
                                        Button(action: {
                                            Homemodel.addToCartTest(item: item)
                                            showAlertAdd.toggle()
                                        }) {
                                            AccessoriesView(item: item)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .padding(.horizontal,4)
                        }
                    }
                    .padding(.bottom,100)
                }
            }
        }
        .popup(isPresented: $status, type: .toast, position: .top, autohideIn: 4) {
            OrderTopToast()
        }
        .popup(isPresented: $showingPopup, type: .toast, position: .top, autohideIn: 2) {
            createTopToast()
        }
        .popup(isPresented: $showAlert, type: .toast, position: .top, autohideIn: 2) {
            alertTopToast()
        }
        .popup(isPresented: $showAlertAdd, type: .toast, position: .top, autohideIn: 2) {
            createTopToastAdd()
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear{
            settings.fetchAndMapSettings()
            orderData.fetchAndMap()
            userData.fetchAndMap()
            Homemodel.locationManager.delegate = Homemodel
            Homemodel.fetchData()
            Homemodel.fetchDataAccessories()
            Homemodel.fetchDataEvents()
//            userData.updateToken()
//            chatData.createChannel(user: userID ?? "")
            clientModel.fetchClientAdress(client: userID ?? "")
        }
    }
    func getPrice(value: Float)->String{
        
        let format = NumberFormatter()
        
        return format.string(from: NSNumber(value: value)) ?? ""
    }
    
    func createTopToast() -> some View {
        VStack {
            Spacer(minLength: 20)
            HStack() {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("Пока пусто")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    Text("Выберите услуги ниже и добавьте в корзину!")
                        .lineLimit(2)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
            }
            .padding(15)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
        .background(Color("blue"))
    }
    func createTopToastAdd() -> some View {
        VStack {
            Spacer(minLength: 20)
            HStack() {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("Добавили в корзину!")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
            }
            .padding(15)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
        .background(Color("blue"))
    }
    func OrderTopToast() -> some View {
        VStack {
            Spacer(minLength: 20)
            HStack() {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("Заказ оформлен")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    Text("Все детали заказа доступны в карточке профиля")
                        .lineLimit(2)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
            }
            .padding(15)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
        .background(Color("blue"))
    }
    func alertTopToast() -> some View {
        VStack {
            Spacer(minLength: 20)
            HStack() {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("Есть активный заказ!")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    Text("Чтобы оформить новый заказ, отмените старый")
                        .lineLimit(2)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
            }
            .padding(15)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
        .background(Color.red)
    }
}

