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
    @State var name = ""
    @State var next = false
    @State var isSmallDevice = UIScreen.main.bounds.height < 750
    @StateObject var userData = UserView()
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
                VStack(spacing: 20) {
                    VStack(alignment: .leading,spacing: 20){
                        VStack{
                            HStack{
                                Text("iPhone 12 Pro Max")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 12 Pro Max" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 12 Pro Max"
                        }
                        VStack{
                            HStack{
                                Text("iPhone 12 Pro")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 12 Pro" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 12 Pro"
                        }
                        VStack{
                            HStack{
                                Text("iPhone 12 Mini")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 12 Mini" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 12 Mini"
                        }
                        VStack{
                            HStack{
                                Text("iPhone 12")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 12" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 12"
                        }
                        VStack{
                            HStack{
                                Text("iPhone 11 Pro Max")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 11 Pro Max" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 11 Pro Max"
                        }
                        VStack{
                            HStack{
                                Text("iPhone 11 Pro")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 11 Pro" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 11 Pro"
                        }
                        VStack{
                            HStack{
                                Text("iPhone 11")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 11" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 11"
                        }
                        VStack{
                            HStack{
                                Text("iPhone XS Max")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone XS Max" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone XS Max"
                        }
                        VStack{
                            HStack{
                                Text("iPhone XS")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone XS" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone XS"
                        }
                    }
                    VStack(alignment: .leading,spacing: 20){
                        VStack{
                            HStack{
                                Text("iPhone XR")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone XR" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone XR"
                        }
                        VStack{
                            HStack{
                                Text("iPhone SE (2nd Gen)")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone SE (2nd Gen)" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone SE (2nd Gen)"
                        }
                        VStack{
                            HStack{
                                Text("iPhone X")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone X" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone X"
                        }
                        VStack{
                            HStack{
                                Text("iPhone 8 Plus")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 8 Plus" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 8 Plus"
                        }
                        VStack{
                            HStack{
                                Text("iPhone 8")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 8" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 8"
                        }
                        VStack{
                            HStack{
                                Text("iPhone 7 Plus")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 7 Plus" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 7 Plus"
                        }
                        VStack{
                            HStack{
                                Text("iPhone 7")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 7" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 7"
                        }
                    }
                    VStack(alignment: .leading,spacing: 20){
                        VStack{
                            HStack{
                                Text("iPhone 6s Plus")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 6s Plus" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 6s Plus"
                        }
                        VStack{
                            HStack{
                                Text("iPhone 6s")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 6s" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 6s"
                        }
                        VStack{
                            HStack{
                                Text("iPhone 6 Plus")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 6 Plus" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 6 Plus"
                        }
                        VStack{
                            HStack{
                                Text("iPhone 6")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 6" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 6"
                        }
                        VStack{
                            HStack{
                                Text("iPhone SE")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone SE" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone SE"
                        }
                        VStack{
                            HStack{
                                Text("iPhone 5s")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 5s" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 5s"
                        }
                        VStack{
                            HStack{
                                Text("iPhone 5")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image("checkmark")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(name == "iPhone 5" ? 1 : 0)
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 103)
                        .background(Color("blue"))
                        .cornerRadius(20)
                        .onTapGesture {
                            name = "iPhone 5"
                        }
                    }
                }
                
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                userData.updatePhoneModel(phone: name)
                self.present.wrappedValue.dismiss()
            }) {
                ZStack{
                    Rectangle()
                        .fill(name != "" ? Color("blue") : Color.white)
                        .frame(width: UIScreen.main.bounds.width - 50,height: 56)
                        .cornerRadius(12)
                        .shadow(color: Color.gray.opacity(0.04), radius: 1, x: 5, y: 5)
                        .shadow(color: Color.gray.opacity(0.04), radius: 1, x: -5, y: -5)
                    HStack(spacing: 2){
                        Text("Далее")
                            .fontWeight(.bold)
                            .foregroundColor(name != "" ? Color.white : Color.black.opacity(0.3))
                    }
                }
            }
        }
        .preferredColorScheme(.light)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
