//
//  AdressChoose.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import CoreLocation
import BottomSheet
import iTextField

struct AdressCoise : View {
    @State var title = ""
    @State var subtitle = ""
    @State var comment_text = ""
    @State var showingPopup = false
    @StateObject var Homemodel = HomeViewModel()
    @StateObject var clientModel = ClientInfo()
    @StateObject var userData = UserView()
    @State var manager = CLLocationManager()
    @AppStorage("first_lanch") var lanch = false
    @AppStorage("log_Status") var status = false
    var body: some View {
        ZStack(alignment: .bottom, content: {
            MapView(title: self.$title, manager: $manager, subtitle: self.$subtitle).ignoresSafeArea(.all)
            
            VStack {
                HStack{
                    Spacer()
                    Button(action: {
                        UserDefaults.standard.setValue(self.title, forKey: "ClientStreet")
                        UserDefaults.standard.setValue(self.comment_text, forKey: "ClientComment")
                        clientModel.addAdress(street: self.title, comment: self.comment_text, current: true)
                        userData.setCurrentAdress(adress: self.title)
                        withAnimation{status = true}
                    }){
                        ZStack{
                            Circle()
                                .fill(Color("blue").opacity(0.6))
                                .frame(width: 44,height: 46)
                            Image("checkmark")
                                .frame(width: 20,height: 20)
                        }
                    }
                    
                    .opacity(self.comment_text != "" ? 1 : 0)
                }.padding([.horizontal,.bottom])
                .padding(.top,10)
                .padding()
                Spacer()
                VStack(spacing: 15) {
                    HStack {
                        Text("Адрес")
                            .font(.system(size: 16), weight: .medium)
                            .foregroundColor(.black)
                        Spacer()
                    }
        //            .padding()
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.06))
                            .frame(width: UIScreen.main.bounds.width - 70,height: 50)
                            .cornerRadius(10)
                        HStack {
                            if self.title == "" {
                                Text("Укажите свой адрес")
                                    .fontWeight(.regular)
                                    .foregroundColor(.black)
                            }
                            else {
                                Text(self.title)
                                    .fontWeight(.regular)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                        }.padding()
                    }
                    HStack {
                        Text("Комментарий")
                            .font(.system(size: 16), weight: .medium)
                            .foregroundColor(.black)
                        Spacer()
                    }
        //            .padding()
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.06))
                            .frame(width: UIScreen.main.bounds.width - 70,height: 50)
                            .cornerRadius(10)
                        HStack {
                            if comment_text == "" {
                                Text("Квартира, этаж, подъезд")
                                    .foregroundColor(.black.opacity(0.4))
                            }
                            else {
                                Text(comment_text)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                        }.padding()
                        .onTapGesture {
                            self.showingPopup.toggle()
                        }
                    }
                }
                .padding()
                .padding(.bottom,25)
                .background(Color.white)
                .cornerRadius(25)
                .padding(.vertical)
                .padding(.bottom)
                .padding(.horizontal,25)
                .shadow(color: Color.black.opacity(0.04), radius: 5, x: 5, y: 5)
            }
            
        })
        .onAppear{
            Homemodel.locationManager.delegate = Homemodel
            userData.createUser(bonus: 0)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .bottomSheet(isPresented: $showingPopup, height: 600){
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.06))
                        .frame(width: UIScreen.main.bounds.width - 50 ,height: 50)
                        .cornerRadius(10)
                        .padding()
                    iTextField("Квартира, этаж, подъезд",text: $comment_text)
                        .accentColor(Color("blue"))
                        .keyboardType(.default)
                        .returnKeyType(.continue)
                        .disableAutocorrection(true)
                        .autocapitalization(.words)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 60,height: 50)
                }.ignoresSafeArea(.keyboard)
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    func createPopup() -> some View {
        VStack(spacing: 40) {
            
            VStack(alignment: .leading, spacing: 10){
                Text("Комментарий")
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.06))
                        .frame(width: 280,height: 50)
                        .cornerRadius(10)
                    TextField("",text: $comment_text)
                        .frame(width: 280,height: 50)
                        .cornerRadius(10)
                }
            }

            

            Button(action: {
                self.showingPopup = false
            }) {
                Text("Закрыть")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .frame(width: 100, height: 40)
            .background(Color("blue"))
            .cornerRadius(10.0)
        }
        .padding(EdgeInsets(top: 70, leading: 20, bottom: 40, trailing: 20))
        .frame(width: 300, height: 200)
        .background(Color.white)
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
    }
}

