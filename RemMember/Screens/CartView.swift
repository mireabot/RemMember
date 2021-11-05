//
//  CartView.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase
import SDWebImageSwiftUI
import BottomSheet

struct CartView : View {
    @State var isSwitchOn = false
    @State var showTypes = false
    @ObservedObject var homeData: HomeViewModel
    @StateObject var homeModel = HomeViewModel()
    @StateObject var viewModel = StatsModel()
    @State var payment_type = ""
    @State var repair_type = ""
    @AppStorage("orderCreated") var status = false
    @AppStorage("trig") var trig = false
    @Environment(\.presentationMode) var present
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
        ZStack {
            VStack {
                HStack{
                    HStack(spacing: 10){
                        Button(action: {
                            self.present.wrappedValue.dismiss()
                        }) {
                            ZStack{
                                Circle()
                                    .fill(Color.black.opacity(0.05))
                                    .frame(width: 34,height: 34)
                                Image("arrow.left")
                                    .frame(width: 24, height: 24)
                            }
                        }
                        Text("Корзина")
                            .font(.system(size: 24))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
                .padding()
                HStack {
                    VStack(alignment: .leading, spacing: 10){
                        HStack(spacing: 5){
                            Text("Мастер приедет через")
                                .foregroundColor(.black)
                            Text("30 минут")
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                        }
                        Rectangle()
                            .fill(Color("blue"))
                            .frame(width: 207,height: 4)
                            .cornerRadius(10)
                    }
                    Spacer()
                }.padding()
                ForEach(homeData.cartItems){ cart in
                    HStack {
                        HStack(spacing: 20) {
                            WebImage(url: URL(string: cart.item.item_image))
                                .resizable()
                                .frame(width: 33,height: 69)
                            VStack(alignment: .leading, spacing: 5){
                                Text(cart.item.item_name)
                                    .foregroundColor(.black)
                                HStack(spacing: 2){
                                    Text(getPrice(value: Float(truncating: cart.item.item_cost)))
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    Text("₽")
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                }
                                
                            }
                            Spacer()
                            Button(action: {
                                let index = homeData.getIndex(item: cart.item, isCartIndex: true)
                                let itemIndex = homeData.getIndex(item: cart.item, isCartIndex: false)
                                
                                let filterIndex = homeData.filtered.firstIndex { (item1) -> Bool in
                                    return cart.item.id == item1.id
                                } ?? 0
                                
                                homeData.items[itemIndex].isAdded = false
                                homeData.filtered[filterIndex].isAdded = false
                                
                                homeData.cartItems.remove(at: index)
                            }) {
                                Image("xmark")
                            }
                        }
                    }.padding()
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: UIScreen.main.bounds.width - 20, height: 1)
                }
                
                ForEach(homeData.cartItemsAcc){ cart in
                    HStack {
                        HStack(spacing: 20) {
                            WebImage(url: URL(string: cart.accessori.item_image))
                                .resizable()
                                .frame(width: 80, height: 80)
                            VStack(alignment: .leading, spacing: 5){
                                Text(cart.accessori.item_name)
                                    .foregroundColor(.black)
                                HStack(spacing: 2){
                                    Text(getPrice(value: Float(truncating: cart.accessori.item_cost)))
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    Text("₽")
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                }
                                
                            }
                            Spacer()
                            Button(action: {
                                let index = homeData.getIndexTest(item: cart.accessori, isCartIndex: true)
                                let itemIndex = homeData.getIndexTest(item: cart.accessori, isCartIndex: false)
                                
                                let filterIndex = homeData.filtered.firstIndex { (item1) -> Bool in
                                    return cart.accessori.id == item1.id
                                } ?? 0
                                
                                homeData.items[itemIndex].isAdded = false
                                homeData.filtered[filterIndex].isAdded = false
                                
                                homeData.cartItemsAcc.remove(at: index)
                            }) {
                                Image("xmark")
                            }
                        }
                    }.padding()
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: UIScreen.main.bounds.width - 20, height: 1)
                }
                Spacer()
                
                Button(action: {
                    self.isSwitchOn.toggle()
                }){
                    
                    Text("Далее")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(
                            Color("blue")
                        )
                        .cornerRadius(15)
                    
                }
            }.preferredColorScheme(.light)
            .opacity(isSwitchOn == true ? 0 : 1)
            .onAppear{
                homeModel.fetchAdds()
                viewModel.fetchAndMapStats()
            }
            
            VStack {
                HStack{
                    HStack(spacing: 10){
                        Button(action: {
                            self.isSwitchOn.toggle()
                        }) {
                            ZStack{
                                Circle()
                                    .fill(Color.black.opacity(0.05))
                                    .frame(width: 34,height: 34)
                                Image("arrow.left")
                                    .frame(width: 24, height: 24)
                            }
                        }
                        Text("Оформление")
                            .font(.system(size: 24))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
                .padding()
                Header(title: "Способ оплаты", color: .black).padding()
                VStack(spacing: 35) {
                    HStack {
                        HStack {
                            Button(action: {
                                self.payment_type = "Картой мастеру"
                            }) {
                                ZStack {
                                    if self.payment_type == "Картой мастеру" {
                                        Circle()
                                            .fill(Color("blue_light"))
                                            .frame(width: 20, height: 20)
                                    }
                                    else {
                                        Circle()
                                            .stroke(Color.black.opacity(0.09),lineWidth: 1)
                                            .frame(width: 20, height: 20)
                                    }
                                    Image("checkmark")
                                        .resizable()
                                        .frame(width: 15,height: 15)
                                }
                            }
                            Text("Картой мастеру")
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                        }
                        Spacer()
                    }
                    HStack {
                        HStack {
                            Button(action: {
                                self.payment_type = "Наличными мастеру"
                            }) {
                                ZStack {
                                    if self.payment_type == "Наличными мастеру"  {
                                        Circle()
                                            .fill(Color("blue_light"))
                                            .frame(width: 20, height: 20)
                                    }
                                    else {
                                        Circle()
                                            .stroke(Color.black.opacity(0.09),lineWidth: 1)
                                            .frame(width: 20, height: 20)
                                    }
                                    Image("checkmark")
                                        .resizable()
                                        .frame(width: 15,height: 15)
                                }
                            }
                            Text("Наличными мастеру")
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                        }
                        Spacer()
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
                
                ZStack {
                    Header(title: "Где будет ремонт?", color: .black).padding()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showTypes.toggle()
                        }) {
                            Text("Что это?")
                                .fontWeight(.medium)
                                .font(.system(size: 14))
                                .foregroundColor(Color("blue_light"))
                        }
                    }
                    .padding()
                }
                VStack(spacing: 35) {
                    HStack {
                        HStack {
                            Button(action: {
                                self.repair_type = "Ремонт в офисе"
                            }) {
                                ZStack {
                                    if self.repair_type == "Ремонт в офисе" {
                                        Circle()
                                            .fill(Color("blue_light"))
                                            .frame(width: 20, height: 20)
                                    }
                                    else {
                                        Circle()
                                            .stroke(Color.black.opacity(0.09),lineWidth: 1)
                                            .frame(width: 20, height: 20)
                                    }
                                    Image("checkmark")
                                        .resizable()
                                        .frame(width: 15,height: 15)
                                }
                            }
                            Text("Ремонт в офисе")
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                        }
                        Spacer()
                    }
                    HStack {
                        HStack {
                            Button(action: {
                                self.repair_type = "Ремонт на выезде"
                            }) {
                                ZStack {
                                    if self.repair_type == "Ремонт на выезде"  {
                                        Circle()
                                            .fill(Color("blue_light"))
                                            .frame(width: 20, height: 20)
                                    }
                                    else {
                                        Circle()
                                            .stroke(Color.black.opacity(0.09),lineWidth: 1)
                                            .frame(width: 20, height: 20)
                                    }
                                    Image("checkmark")
                                        .resizable()
                                        .frame(width: 15,height: 15)
                                }
                            }
                            .disabled(trig ? true : false)
                            Text("Ремонт на выезде")
                                .fontWeight(.medium)
                                .foregroundColor(!trig ? .black : .gray)
                                .font(.system(size: 16))
                        }
                        Spacer()
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
                Spacer()
                
                VStack {
                    HStack {
                        Text("Итого")
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(homeData.calculateTotalPrice()) ₽")
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }.padding()
                    
                    Button(action: {
                        self.trig = false
                        homeData.SetAmountStats(count: Int(homeData.calculateTotalPrice()) ?? 0, oldCount: viewModel.stats.amount ?? 0)
                        homeData.SetOrdersStats(count: 1, oldCount: viewModel.stats.orders ?? 0)
                        homeData.createOrder(type: payment_type,location: repair_type)
                        homeData.createOrderHistory()
                        withAnimation{status = true}
                        self.present.wrappedValue.dismiss()
                    }){
                        Text("Оформить заказ")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 30)
                            .background( self.payment_type != "" && self.repair_type != "" ? Color("blue") : Color.black.opacity(0.3))
                            .cornerRadius(15)
                    }
                    .disabled(self.payment_type != "" && self.repair_type != "" ? false : true)
                }
            }
            .bottomSheet(isPresented: $showTypes, height: 600){
                RepairTypes()
            }
            .preferredColorScheme(.light)
            .onAppear{
                viewModel.fetchAndMapStats()
            }
            .opacity(isSwitchOn == true ? 1 : 0)
        }
    }
    func getPrice(value: Float)->String{
        
        let format = NumberFormatter()
        
        return format.string(from: NSNumber(value: value)) ?? ""
    }
}


struct RepairTypes : View {
    var body: some View {
        VStack {
            HStack {
                Text("Ремонт в офисе")
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                Spacer()
            }.padding()
            Text("Данную услугу можно произвести исключительно в ремонтонм центре, наш ассистент заберет устройство и доставит после выполнения ремонтных работ👍")
                .font(.system(size: 16))
                .fontWeight(.medium)
                .foregroundColor(.black)
                .padding()
            HStack {
                Text("Ремонт на выезде")
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                Spacer()
            }.padding()
            Text("Данную услугу можно осуществить инженером на выезде. Мастер привезет необходимые запчасти и выполнит ремонт на вашей локации,  главное чтобы была свободная поверхность 😊")
                .font(.system(size: 16))
                .fontWeight(.medium)
                .foregroundColor(.black)
                .padding()
        }
    }
}

struct RepairTypes_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmCancel()
    }
}


struct ConfirmCancel : View {
    var body: some View {
        VStack(spacing: 35) {
            Text("Вы хотите отменить заказ?")
                .font(.system(size: 16))
                .fontWeight(.medium)
                .foregroundColor(.black)
            HStack {
                Button(action: {
                    
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

