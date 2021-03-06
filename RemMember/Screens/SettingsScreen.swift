//
//  SettingsScreen.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase
import AlertX

struct SettingsScreen : View {
    @Environment(\.presentationMode) var present
    @State var profile_settings : ProfileSettings = profileSettings[0]
    @State var app_info_settings : AppInfoSettings = InfoSettings[0]
    @State var confirm = false
    @AppStorage("log_Status") var status = false
    @AppStorage("isLoggedIn") var isLogin: Bool = false
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
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
    @State var show_updates = false
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
                    Button(action: {
                        show_updates.toggle()
                    }) {
                        HStack {
                            
                            Text("Что нового?").foregroundColor(.black).font(.system(size: 20))
                            
                            Spacer(minLength: 10)
                            
                            Image("new").renderingMode(.original).resizable().frame(width: 24,height: 24)
                            
                        }.padding()
                    }
                    .fullScreenCover(isPresented: $show_updates) {
                        UpdatePage()
                    }
                }
                Spacer()
                HStack {
                    Button(action: {
                        confirm.toggle()
                    }){
                        Text("Выйти")
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                    }
                    .alertX(isPresented: $confirm, content: {
                        
                        AlertX(title: Text("Вы действительно хотите выйти?"),
                               primaryButton: .cancel(Text("Закрыть"),action: {
                            self.confirm = false
                        }),
                               secondaryButton: .default(Text("Выйти"), action: {
                            self.present.wrappedValue.dismiss()
                            try? Auth.auth().signOut()
                            withAnimation{
                                status = false
                                isLogin = false
                                
                            }
                        }),
                               theme: .custom(windowColor: Color.white, alertTextColor: Color.black, enableShadow: false, enableRoundedCorners: true, enableTransparency: true, cancelButtonColor: Color.black, cancelButtonTextColor: Color.white, defaultButtonColor: Color.red, defaultButtonTextColor: Color.white),
                               animation: .fadeEffect())
                    })
                    Spacer()
                }.padding()
                Spacer()
                VStack(spacing: 10){
                    Text("Версия \(appVersion ?? "") сборка \(bundleVersion ?? "")")
                        .font(.system(size: 14))
                        .foregroundColor(.black.opacity(0.4))
                        .fontWeight(.regular)
                    Text("Все права защищены @RemMember")
                        .font(.system(size: 14))
                        .foregroundColor(.black.opacity(0.4))
                        .fontWeight(.regular)
                }
                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .preferredColorScheme(.light)
        .edgesIgnoringSafeArea(.bottom)
    }
}


