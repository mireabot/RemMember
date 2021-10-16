//
//  MyDevice.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase

struct MyDevice : View {
    @State var client_device = UserDefaults.standard.string(forKey: "ClientDevice")
    @StateObject var Homemodel = HomeViewModel()
    func Header(title: String,color: Color) -> HStack<TupleView<(Text, Spacer)>> {
        return // since both are same so were going to make it as reuable...
            HStack{
                
                Text(title)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                
                Spacer()
            }
    }
    var body: some View {
        VStack {
            ForEach(Homemodel.user_phones){ phone in
                VStack(spacing: 20){
                    PhoneView(phone: phone)
//                        .onTapGesture {
//                            UserDefaults.standard.setValue(phone.phone_name, forKey: "ClientDevice")
//                            UserDefaults.standard.synchronize()
//                            print(phone.phone_name)
//                        }
                }
            }
            Spacer()
            Button(action: {
                
            }){
                ZStack{
                    Rectangle()
                        .fill(Color("blue"))
                        .frame(width: UIScreen.main.bounds.width - 50,height: 56)
                        .cornerRadius(12)
                        .shadow(color: Color.gray.opacity(0.04), radius: 1, x: 5, y: 5)
                        .shadow(color: Color.gray.opacity(0.04), radius: 1, x: -5, y: -5)
                    HStack(spacing: 2){
                        Text("Добавить устройство")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    }
                }
            }
        }.onAppear{
            Homemodel.fetchClientPhones(client: Auth.auth().currentUser!.uid)
        }
    }
}


struct Device_Previews: PreviewProvider {
    static var previews: some View {
        MyDevice()
    }
}

