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
            NavigationLink(destination: DeviceChoiseTest()){
                ZStack{
                    Rectangle()
                        .fill(Color("blue"))
                        .frame(width: UIScreen.main.bounds.width - 50,height: 56)
                        .cornerRadius(12)
                        .shadow(color: Color.gray.opacity(0.04), radius: 1, x: 5, y: 5)
                        .shadow(color: Color.gray.opacity(0.04), radius: 1, x: -5, y: -5)
                    HStack(spacing: 2){
                        Text("Изменить устройство")
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

struct DeviceChoiseTest : View {
    
    @State var device : Devices = devices[0]
    @State var tap = false
    @State var detail = false
    @State var next = false
    @State var isSmallDevice = UIScreen.main.bounds.height < 750
    @StateObject var Homemodel = HomeViewModel()
    @AppStorage("log_Status") var status = false
    @Environment(\.presentationMode) var present
    var body: some View{
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
                Text("Изменить устройство")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                Spacer()
                
            }
            .padding()
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading,spacing: 20){
                    
                    ForEach(devices){item in
                        DeviceView(item: item)
                            .onTapGesture {
                                device.active = true
//                                self.tap = true
//                                device = item
//                                print(device.title)
                            }
                        
                    }
                }
                
            }
            .padding()
            
            Spacer()
            
            ZStack{
                Rectangle()
                    .fill(self.tap == true ? Color("blue") : Color.white)
                    .frame(width: 160,height: 56)
                    .cornerRadius(12)
                    .shadow(color: Color.gray.opacity(0.04), radius: 1, x: 5, y: 5)
                    .shadow(color: Color.gray.opacity(0.04), radius: 1, x: -5, y: -5)
                HStack(spacing: 2){
                    Text("Далее")
                        .fontWeight(.bold)
                        .foregroundColor(self.tap == true ? Color.white : Color.black.opacity(0.3))
                }
            }
        }
        .preferredColorScheme(.light)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
