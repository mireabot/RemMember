//
//  MapViews.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation
import BottomSheet
import Combine
import iTextField

struct Map : View {
    @State var title = ""
    @State var subtitle = ""
    @State var comment_text = ""
    @State var showingPopup = false
    @StateObject var Homemodel = HomeViewModel()
    @StateObject var clientModel = ClientInfo()
    @State var manager = CLLocationManager()
    @Environment(\.presentationMode) var present
    var body: some View {
        ZStack(alignment: .bottom, content: {
            MapView(title: self.$title, manager: $manager, subtitle: self.$subtitle).ignoresSafeArea(.all)
            
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
                    }
                    
                    Spacer()
                    
//                    Button(action: {
//                        clientModel.addAdress(street: self.title, comment: self.comment_text, current: false)
//                        self.present.wrappedValue.dismiss()
//                    }) {
//                        ZStack{
//                            Circle()
//                                .fill(Color("blue").opacity(0.6))
//                                .frame(width: 44,height: 46)
//                            Image("checkmark")
//                                .frame(width: 20,height: 20)
//                        }
//                    }.opacity(self.comment_text != "" && self.title != "" ? 1 : 0)
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
                
                Button(action: {
                    showingPopup.toggle()
                    clientModel.addAdress(street: self.title, comment: self.comment_text, current: false)
                    self.present.wrappedValue.dismiss()
                }){
                    ZStack{
                        Rectangle()
                            .fill(Color("blue"))
                            .frame(width: UIScreen.main.bounds.width - 60,height: 56)
                            .cornerRadius(12)
                            .shadow(color: Color.gray.opacity(0.04), radius: 1, x: 5, y: 5)
                            .shadow(color: Color.gray.opacity(0.04), radius: 1, x: -5, y: -5)
                        HStack(spacing: 2){
                            Text("Добавить адрес")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                    }
                }.opacity(comment_text != "" ? 1 : 0)
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear{
            if manager.location?.coordinate.latitude ?? 0.0 > 55.733842 {
                print("Out of location")
            }
            Homemodel.locationManager.delegate = Homemodel
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}


