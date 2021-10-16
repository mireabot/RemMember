//
//  ContentView.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var animate = false
    @State private var endSplash = false
    @AppStorage("log_Status") var status = false
    @State var showAlert = false
    var body: some View {
            if status{
                
                NavigationView {
                    CustomTabView()
                        .navigationTitle("")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarHidden(true)
                        .preferredColorScheme(.light)
                }
            }
            else{
                
                ContentView1()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContentView1: View {
    
    @AppStorage("isLoggedIn") var isLogin: Bool = false
    
    var body: some View {
        if isLogin {
            NavigationView {
                NamePage()
            }
        }else {
            Login()
        }
    }
}
