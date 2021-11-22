//
//  PhoneEdit.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 20.11.2021.
//

import Foundation
import SwiftUI
import iTextField

struct PhoneEdit : View {
    @StateObject var userData = UserView()
    @State var phone_field = ""
    @Environment(\.presentationMode) var present
    var body: some View {
        VStack {
            HStack {
                Text("Изменение номера")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .font(.system(size: 24))
                Spacer()
            }.padding()
            Spacer()
            VStack(spacing: 15) {
                iTextField("Ваш новый номер", text: $phone_field)
                    .accentColor(Color("blue"))
                    .keyboardType(.phonePad)
                    .returnKeyType(.done)
                    .autocapitalization(.none)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 40, height: 40)
                
                Button(action: {
                    userData.updatePhone(phone: phone_field)
                    UserDefaults.standard.setValue(phone_field, forKey: "Clientnumber")
                    self.present.wrappedValue.dismiss()
                }){
                    ZStack{
                        Rectangle()
                            .fill(Color("blue"))
                            .frame(width: UIScreen.main.bounds.width - 50,height: 56)
                            .cornerRadius(12)
                            .shadow(color: Color.gray.opacity(0.04), radius: 1, x: 5, y: 5)
                            .shadow(color: Color.gray.opacity(0.04), radius: 1, x: -5, y: -5)
                        HStack(spacing: 2){
                            Text("Изменить номер")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                    }
                }
            }
            Spacer()
        }.preferredColorScheme(.light)
    }
}
