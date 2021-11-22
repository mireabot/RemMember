//
//  NamePage.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase

struct NamePage : View {
    @State var Clientname = ""
    @StateObject var Homemodel = HomeViewModel()
    @AppStorage("current_user") var user = ""
    var body: some View {
        VStack {
            HStack{
                VStack(alignment: .leading,spacing:0){
                    Text("Welcome to")
                        .font(.system(size: 28))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .padding(.leading,10)
                    Image("logo")
                        .resizable()
                        .frame(width: 174, height: 46)
                    Text("Давайте познакомимся")
                        .padding(.leading,10)
                        .foregroundColor(Color.black.opacity(0.6))
                        .font(.system(size: 14))
                }
                Spacer()
            }.padding()
            
            Spacer()
            
            HStack(spacing: 12){
                Image("profile")
                    .resizable()
                    .frame(width: 24, height: 24)
                
                TextField("Ваше имя", text: $Clientname)
            }.padding()
            Rectangle()
                .fill(Color.gray.opacity(0.4))
                .frame(width: UIScreen.main.bounds.width - 40, height: 1)
            
            Spacer()
            
            NavigationLink(destination: DeviceChoise()){
                ZStack{
                    Rectangle()
                        .fill(Clientname == "" ? Color.white : Color("blue"))
                        .frame(width: UIScreen.main.bounds.width - 50,height: 56)
                        .cornerRadius(12)
                        .shadow(color: Color.gray.opacity(0.04), radius: 1, x: 5, y: 5)
                        .shadow(color: Color.gray.opacity(0.04), radius: 1, x: -5, y: -5)
                    HStack(spacing: 2){
                        Text("Далее")
                            .fontWeight(.bold)
                            .foregroundColor(Clientname == "" ? Color.black.opacity(0.3) : Color.white)
                    }
                }
            }.disabled(Clientname == "" ? true : false)
            .simultaneousGesture(TapGesture().onEnded{
                user = Clientname
                UserDefaults.standard.setValue(Clientname, forKey: "ClientName")
                UserDefaults.standard.synchronize()
            })
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear{
            Homemodel.login()
        }
        .preferredColorScheme(.light)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}


