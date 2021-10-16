//
//  DeviceChoose.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI

struct DeviceChoise : View {
    
    @State var device : Devices = devices[0]
    @State var tap = false
    @State var detail = false
    @State var next = false
    @State var isSmallDevice = UIScreen.main.bounds.height < 750
    @StateObject var Homemodel = HomeViewModel()
    @AppStorage("log_Status") var status = false
    var body: some View{
        VStack{
            HStack {
                VStack(alignment: .leading, spacing: 5){
                    Text("Какое у вас")
                        .foregroundColor(.black)
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                    Text("устройство?")
                        .foregroundColor(.black)
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                    Text("Опрос создан для подборки услуг нужных Вам")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
                Spacer()
            }.padding()
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading,spacing: 20){
                    
                    ForEach(devices){item in
                        DeviceView(item: item)
                            .onTapGesture {
                                self.tap = true
                                device = item
                                print(device.title)
                            }
                        
                    }
                }
                
            }
            .padding()
            
            Spacer()
            
            NavigationLink(destination: LocationPermition()){
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
//            .disabled(self.tap == true ? false : true)
            .simultaneousGesture(TapGesture().onEnded{
                UserDefaults.standard.setValue(device.title, forKey: "ClientDevice")
                UserDefaults.standard.synchronize()
                Homemodel.addPhone(phone: device.title)
            })
        }
        .preferredColorScheme(.light)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}



