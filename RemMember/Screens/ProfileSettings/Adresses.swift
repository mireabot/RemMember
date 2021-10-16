//
//  Adresses.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase

struct MyAdresses : View {
    @State var street = ""
    @State var house = ""
    @State var apt = ""
    @State var floor = ""
    @State var pad = ""
    @State var addAdress = false
    @State var userID = ""
    @StateObject var clientModel = ClientInfo()
    var body: some View {
        VStack {
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
            print("ID:\(userID)")
            self.clientModel.fetchClientAdress(client: Auth.auth().currentUser!.uid)
            guard let retrive6  = UserDefaults.standard.string(forKey: "UserID") else { return }
            self.userID = retrive6
        }
    }
}

