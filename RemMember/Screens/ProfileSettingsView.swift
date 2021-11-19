//
//  ProfileSettingsView.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI

struct SettingsDetailProfile : View {
    var settings : ProfileSettings
    @Environment(\.presentationMode) var present
    var body: some View {
        ZStack {
            Color.gray.opacity(0.04).edgesIgnoringSafeArea(.all)
            VStack {
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
                    Text(settings.name)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                    Spacer()
                    
                }
                .padding()
                
                if settings.name == "Мое устройство"{
                    MyDevice()
                }
                if settings.name == "Адреса"{
                    MyAdresses()
                }
                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .preferredColorScheme(.light)
    }
}



struct SettingsDetailApp : View {
    var settings : AppInfoSettings
    @Environment(\.presentationMode) var present
    var body: some View {
        ZStack {
            Color.gray.opacity(0.04).edgesIgnoringSafeArea(.all)
            VStack {
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
                    Text(settings.name)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                    Spacer()
                    
                }
                .padding()
                
                
                
                if settings.name == "Оферта"{
                    UrlWebView(urlToDisplay: URL(string: "https://remmember.ru/offer.html")!)
                }
                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .preferredColorScheme(.light)
    }
}

