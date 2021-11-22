//
//  Permitions.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsPermitions()
    }
}

struct LocationPermition : View {
    @StateObject var Homemodel = HomeViewModel()
    var body: some View {
        VStack {
            VStack(spacing: 25){
                Image("location")
                VStack {
                    Text("Разрешите доступ")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("к местоположению")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                Text("Она нам понадобится для вызова мастера")
                    .fontWeight(.regular)
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.5))
                
                NavigationLink(destination: Map(flowState: .afterRegistration)){
                    ZStack{
                        Rectangle()
                            .fill(Color("blue"))
                            .frame(width: 220,height: 56)
                            .cornerRadius(12)
                            .shadow(color: Color.gray.opacity(0.04), radius: 1, x: 5, y: 5)
                            .shadow(color: Color.gray.opacity(0.04), radius: 1, x: -5, y: -5)
                        HStack(spacing: 2){
                            Text("Продолжить")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                    }
                }.disabled(Homemodel.permissionDenied != false ? true : false)
            }
        }
        .onAppear{
            Homemodel.locationManager.delegate = Homemodel
        }
        .alert(isPresented: $Homemodel.permissionDenied, content: {
            
            Alert(title: Text("Доступ отказан"), message: Text("Включите доступ в настройках приложения"), dismissButton: .default(Text("Перейти"), action: {
                
                // Redireting User To Settings...
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
        .preferredColorScheme(.light)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct NotificationsPermitions : View {
    var body: some View {
        VStack {
            VStack(spacing: 25){
                Image("notification")
                VStack {
                    Text("Разрешите доступ")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("к уведомлениям")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                Text("Чтобы вы всегда были в курсе ваших заказов")
                    .fontWeight(.regular)
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.5))
                
                NavigationLink(destination: Map(flowState: .afterRegistration)){
                    ZStack{
                        Rectangle()
                            .fill(Color("blue"))
                            .frame(width: 220,height: 56)
                            .cornerRadius(12)
                            .shadow(color: Color.gray.opacity(0.04), radius: 1, x: 5, y: 5)
                            .shadow(color: Color.gray.opacity(0.04), radius: 1, x: -5, y: -5)
                        HStack(spacing: 2){
                            Text("Продолжить")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                    }
                }
            }
        }
        .preferredColorScheme(.light)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

