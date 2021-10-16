//
//  AddAdress.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase


struct NewAdressAdd : View {
    @State var street = ""
    @State var apt = ""
    @State var pad = ""
    @State var floor = ""
    @State var house = ""
    @StateObject var clientModel = ClientInfo()
    @Environment(\.presentationMode) var present
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10){
                    Text("Укажите адрес")
                        .font(.system(size: 28))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    Text("Сюда будет приезжать мастер")
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }.padding()
            
            VStack(alignment: .leading, spacing: 20){
                VStack(alignment: .leading, spacing: 8, content: {
                    
                    Text("Улица")
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    TextField("ул. Мясницкая", text: $street)
                        // Increasing Font Size And Changing Text Color...
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.top,5)
                    
                    Divider()
                })
                .padding()
                
                HStack(spacing: 5){
                    VStack(alignment: .leading, spacing: 8, content: {
                        
                        Text("Дом")
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                        
                        TextField("12", text: $house)
                            // Increasing Font Size And Changing Text Color...
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.top,5)
                            .frame(width: 74)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 74, height: 1)
                    })
                    .padding()
                    VStack(alignment: .leading, spacing: 8, content: {
                        
                        Text("Квартира")
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                        
                        TextField("12", text: $apt)
                            // Increasing Font Size And Changing Text Color...
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.top,5)
                            .frame(width: 74)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 74, height: 1)
                    })
                    .padding()
                    VStack(alignment: .leading, spacing: 8, content: {
                        
                        Text("Этаж")
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                        
                        TextField("6", text: $floor)
                            // Increasing Font Size And Changing Text Color...
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.top,5)
                            .frame(width: 74)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 74, height: 1)
                    })
                    .padding()
                }
                VStack(alignment: .leading, spacing: 8, content: {
                    
                    Text("Подъезд")
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    TextField("2", text: $pad)
                        // Increasing Font Size And Changing Text Color...
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.top,5)
                        .frame(width: 74)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 74, height: 1)
                })
                .padding()
                
                Spacer()
            }
            Button(action: {
//                clientModel.addAdress(street: self.tit, comment: <#T##String#>)
                self.present.wrappedValue.dismiss()
            }){
                ZStack{
                    Rectangle()
                        .fill(self.street == "" && self.pad == "" && self.apt == "" && self.floor == "" ? Color.white : Color("blue"))
                        .frame(width: 160,height: 56)
                        .cornerRadius(12)
                        .shadow(color: Color.gray.opacity(0.04), radius: 1, x: 5, y: 5)
                        .shadow(color: Color.gray.opacity(0.04), radius: 1, x: -5, y: -5)
                    HStack(spacing: 2){
                        Text("Далее")
                            .fontWeight(.bold)
                            .foregroundColor(self.street == "" && self.pad == "" && self.apt == "" && self.floor == "" ?  Color.black.opacity(0.3) : Color.white)
                    }
                }
            }.disabled(self.street == "" && self.pad == "" && self.apt == "" && self.floor == "" ? true : false)
        }
//        .onDisappear{
//            self.clientModel.fetchClientAdress()
//        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

