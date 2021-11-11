//
//  AllAccessoriesView.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct AccessoriesAllView : View {
    @Environment(\.presentationMode) var present
    @State var showCart = false
    @StateObject var Homemodel = HomeViewModel()
    var body: some View {
        VStack {
            HStack(spacing: 25){
                
                Button(action: {
                    self.present.wrappedValue.dismiss()
                }) {
                    ZStack{
                        Circle()
                            .fill(Color.black.opacity(0.05))
                            .frame(width: 44,height: 46)
                        Image("arrow.left")
                            .frame(width: 24, height: 24)
                    }
                }
                Text("Аксессуары")
                    .font(.title)
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
                                
                                HStack(spacing: 10){
                                    Spacer()
                                    Button(action: {
                                        self.Homemodel.cartItemsAcc.append(CartAcc(accessori: item))
                                    }){
                                        ZStack{
                                            Rectangle()
                                                .fill(Color("blue"))
                                                .frame(width: 100,height: 43)
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
                                    
                                }
                                .padding(.trailing,5)
                                .padding(.top,70)
                                .padding()
                            }
                        }
                    }
                }
                .padding()
                .padding(.horizontal,4)
            }
        }
        .onAppear {
            Homemodel.fetchDataAccessories()
        }
    }
    func getPrice(value: Float)->String{
        
        let format = NumberFormatter()
        
        return format.string(from: NSNumber(value: value)) ?? ""
    }
}


struct CardPe : View {
    var body: some View {
        ZStack {
            HStack(spacing: 5){
                
                WebImage(url: URL(string: "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MD592?wid=1144&hei=1144&fmt=jpeg&qlt=95&.v=0"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                HStack{
                    
                    
                    Text("Адаптер питания MagSafe 2 45 Вт MacBook Air")
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 0)
                    
                }
                .padding()
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width - 30)
            .background(Color.white)
            .cornerRadius(10)
            // shadows..
            .shadow(color: Color.black.opacity(0.04), radius: 5, x: 5, y: 5)
            
            HStack(spacing: 10){
                Spacer()
                Button(action: {
                    
                }){
                    ZStack{
                        Rectangle()
                            .fill(Color("blue"))
                            .frame(width: 100,height: 43)
                            .cornerRadius(12)
                        HStack(spacing: 2){
                            Text("7400")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("₽")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                }
                
            }
            .padding(.trailing,10)
            .padding(.top,70)
            .padding()
        }
    }
}

struct CardPe_Previews: PreviewProvider {
    static var previews: some View {
        CardPe()
    }
}

