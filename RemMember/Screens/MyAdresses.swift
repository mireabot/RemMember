//
//  MyAdresses.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase

struct Adresses : View {
    @State var street = ""
    @State var house = ""
    @State var apt = ""
    @State var floor = ""
    @State var pad = ""
    @State var addAdress = false
    @StateObject var Homemodel = HomeViewModel()
    @StateObject var clientModel = ClientInfo()
    @State var userID = UserDefaults.standard.string(forKey: "UserID")
    var body: some View {
        VStack {
            HStack{
                Text("Мои адреса")
                    .foregroundColor(.black)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                Spacer()
            }.padding()
            ForEach(clientModel.adresses){ adress in
                AdressView(adresses: adress)
            }
            
            Spacer()
            
            Button(action: {
                self.addAdress.toggle()
            }){
                ZStack{
                    Rectangle()
                        .fill(Color("blue"))
                        .frame(width: UIScreen.main.bounds.width - 60,height: 56)
                        .cornerRadius(12)
                        .shadow(color: Color.gray.opacity(0.04), radius: 1, x: 5, y: 5)
                        .shadow(color: Color.gray.opacity(0.04), radius: 1, x: -5, y: -5)
                    HStack(spacing: 2){
                        Text("Новый адрес")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    }
                }
            }.fullScreenCover(isPresented: $addAdress){
                Map()
                    .preferredColorScheme(.light)
            }
        }
        .preferredColorScheme(.light)
        .onAppear{
            self.clientModel.fetchClientAdress(client: userID ?? "")
        }
    }
}

