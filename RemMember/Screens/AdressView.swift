//
//  AdressView.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import Firebase
import SwiftUI



struct AdressView : View {
    @StateObject var userData = UserView()
    @StateObject var clientModel = ClientInfo()
    var adresses : Adress_Model
    @State var street = UserDefaults.standard.string(forKey: "ClientStreet")
    @State var comment = UserDefaults.standard.string(forKey: "ClientComment")
    @Environment(\.presentationMode) var present
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 10){
                Text("\(adresses.client_street)")
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                Text("\(adresses.client_comment)")
                    .foregroundColor(.black.opacity(0.5))
                    .font(.system(size: 14))
                
            }
            Spacer()
            
            Button(action: {
                userData.setCurrentAdress(adress: adresses.client_street)
                UserDefaults.standard.setValue(self.adresses.client_street, forKey: "ClientStreet")
                UserDefaults.standard.setValue(self.adresses.client_comment, forKey: "ClientComment")
                UserDefaults.standard.synchronize()
                self.present.wrappedValue.dismiss()
            }) {
                ZStack {
                    if street == adresses.client_street && comment == adresses.client_comment {
                        Circle()
                            .fill(Color("blue_light"))
                            .frame(width: 30, height: 30)
                    }
                    else {
                        Circle()
                            .stroke(Color.black.opacity(0.09),lineWidth: 1)
                            .frame(width: 30, height: 30)
                    }
                    Image("checkmark")
                        .resizable()
                        .frame(width: 20,height: 20)
                }
            }.padding()
        }
        .padding()
        Rectangle()
            .fill(Color.black.opacity(0.08))
            .frame(width: UIScreen.main.bounds.width - 30, height: 1)
    }
}

