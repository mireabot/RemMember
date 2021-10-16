//
//  SettingsScreen.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase

struct SettingsScreen : View {
    @Environment(\.presentationMode) var present
    @State var profile_settings : ProfileSettings = profileSettings[0]
    @State var app_info_settings : AppInfoSettings = InfoSettings[0]
    @AppStorage("log_Status") var status = false
    @AppStorage("isLoggedIn") var isLogin: Bool = false
    func Header(title: String,color: Color) -> HStack<TupleView<(Text, Spacer)>> {
        return // since both are same so were going to make it as reuable...
            HStack{
                
                Text(title)
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black.opacity(0.3))
                
                Spacer()
            }
    }
    var body: some View {
        ZStack {
            Color.gray.opacity(0.04).edgesIgnoringSafeArea(.all)
            VStack {
                HStack{
                    HStack(spacing: 10){
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
                        Text("Настройки")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
                .padding()
                Header(title: "Мой профиль", color: Color.black.opacity(0.3))
                    .padding([.horizontal,.bottom])
                    .padding(.top,10)
                    .padding(5)
                VStack(spacing: 10){
                    ForEach(profileSettings){settings in
                        ProfileSettingsView(settings: settings)
                    }
                }
                Header(title: "Информация", color: Color.black.opacity(0.3))
                    .padding([.horizontal,.bottom])
                    .padding(.top,10)
                    .padding(5)
                VStack(spacing: 10){
                    ForEach(InfoSettings){settings in
                        AppInfoSettingsView(settings: settings)
                    }
                }
                Spacer()
                HStack {
                    Button(action: {
                        self.present.wrappedValue.dismiss()
                        try? Auth.auth().signOut()
                        withAnimation{
                            status = false
                            isLogin = false
                            
                        }
                    }){
                        Text("Выйти")
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                    }
                    Spacer()
                }.padding()
                Spacer()
            }
        }
        .preferredColorScheme(.light)
        .edgesIgnoringSafeArea(.bottom)
    }
}


