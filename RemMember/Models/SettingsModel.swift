//
//  SettingsModel.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI

struct ProfileSettings : Identifiable {
    var id = UUID().uuidString
    var image : String
    var name : String
}


var profileSettings : [ProfileSettings] = [
    
    ProfileSettings(image: "point", name: "Адреса"),
    ProfileSettings(image: "vercion", name: "Мое устройство")
    
]

struct ProfileSettingsView : View {
    @State var showDetail = false
    var settings : ProfileSettings
    var body: some View {
        NavigationLink(destination: SettingsDetailProfile(settings: settings)){
            HStack {
                
                Text(settings.name).foregroundColor(.black).font(.system(size: 20))
                
                Spacer(minLength: 10)
                
                Image(settings.image).renderingMode(.original).resizable().frame(width: 24,height: 24)
                
            }.padding()
        }
        ////                        .fullScreenCover(isPresented: $showDetail){
        ////            SettingsDetailProfile(settings: settings)
        ////                .preferredColorScheme(.light)
        //        }
    }
}



struct AppInfoSettings : Identifiable {
    var id = UUID().uuidString
    var image : String
    var name : String
}

var InfoSettings : [AppInfoSettings] = [
    
    //    AppInfoSettings(image: "vercion", name: "Версия"),
    AppInfoSettings(image: "info", name: "Оферта")
    
]

struct AppInfoSettingsView : View {
    @State var showDetail = false
    var settings : AppInfoSettings
    var body: some View {
        NavigationLink(destination: SettingsDetailApp(settings: settings)){
            HStack {
                
                Text(settings.name).foregroundColor(.black).font(.system(size: 20))
                
                Spacer(minLength: 10)
                
                Image(settings.image).renderingMode(.original).resizable().frame(width: 24,height: 24)
                
            }.padding()
        }
        //        .fullScreenCover(isPresented: $showDetail){
        //            SettingsDetailApp(settings: settings)
        //                .preferredColorScheme(.light)
        //        }
    }
}

