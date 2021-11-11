//
//  DetailRepairView.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct Detail: View {
    @State var loadContent = false
    var productModel : iPhones
    @StateObject var Homemodel : HomeViewModel
    @Environment(\.presentationMode) var present
    var body: some View {
        
        
        // optimisation for samller size iphone...
        ScrollView(UIScreen.main.bounds.height < 750 ? .vertical : .init(), content: {
            
            VStack{
                
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
                    
                    Spacer()
                    
                }
                .padding()
                
                VStack(spacing: 20){
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 10){
                            Text(productModel.item_name)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Text("+ \(productModel.item_plus_time)")
                                .fontWeight(.regular)
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(0.3))
                        }
                        
                        Spacer()
                    }.padding()
                    VStack{
                        
                        VStack(alignment: .leading,spacing: 8){
                            
                            Text("Описание")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            
                            Text(productModel.item_details)
                                .foregroundColor(.black)
                                .fontWeight(.regular)
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 30, alignment: .leading)
                        .background(Color("blue_thin"))
                        .cornerRadius(15)
//                        Spacer()
                    }
                    .padding([.horizontal,.bottom])
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 10){
                            Text(productModel.item_type)
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                                .fontWeight(.medium)
                            Text("Работа мастера \(productModel.item_time)")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                                .fontWeight(.medium)
                            HStack {
                                Text("Гаранития 30 дней")
                                    .font(.system(size: 18))
                                    .foregroundColor(.black)
                                    .fontWeight(.medium)
                                Image(systemName: "shield")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color("blue"))
                            }
                        }
                        Spacer()
                    }.padding()
                }
                
                // for smooth transition...
                
                Spacer()
                
                Button(action: {
                    self.present.wrappedValue.dismiss()
                    Homemodel.addToCart(item: productModel)
                }){
                    Text("\(productModel.item_cost) ₽")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(
                            Color("blue")
                        )
                        .cornerRadius(15)
                }.padding(.bottom, 10)
            }
        })
            .navigationTitle("")
            .navigationBarHidden(true)
        .onAppear {
            
            withAnimation(Animation.spring().delay(0.45)){
                loadContent.toggle()
            }
        }
    }
    func getPrice(value: Float)->String{
        
        let format = NumberFormatter()
        
        return format.string(from: NSNumber(value: value)) ?? ""
    }
}

