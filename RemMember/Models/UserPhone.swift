//
//  UserPhone.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI

struct UserPhone : Identifiable {
    
    var id: String
    var phone_name: String
    var client_id: String
    
}


struct PhoneView : View {
    var phone : UserPhone
    @State var name = UserDefaults.standard.string(forKey: "ClientDevice")
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("blue"))
                .cornerRadius(20)
                .frame(width: UIScreen.main.bounds.width - 40, height: 103)
            HStack {
                Text(phone.phone_name)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 30, height: 30)
                    Image(systemName: "checkmark")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                }.opacity(name == phone.phone_name ? 1 : 0)
            }.padding()
        }
        .padding()
    }
}

