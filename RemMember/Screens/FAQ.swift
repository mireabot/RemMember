//
//  FAQ.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct FAQ : View {
    @Environment(\.presentationMode) var present
    var body: some View {
        VStack {
            HStack(spacing: 25){
                Text("FAQ")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
                
            }
            .padding()
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 10){
                    HStack{
                        Text("1. Что такое Remmember?")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        Spacer()
                    }.padding()
                    HStack {
                        Text("Remmember - сервисный центр «нового поколения», основанный на базе сервисного центра Modmac, функционирующего с 2007 года.  Основная задача сервиса, предоставить максимально качественное и удобное обслуживание для клиента. Обеспечить все ремонтные процедуры силами сервиса, без необходимости его посещения клиентом.  ")
                    }.padding()
                    
                    HStack{
                        Text("2. Предоставляется ли гарантия при ремонте?")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        Spacer()
                    }.padding()
                    HStack {
                        Text("Мы предоставляем гарантию на все установленные нами запчасти. В зависимости от категории устанавливаемой запчасти - Оригинал/копия, срок гарантии начинается от 30 дней до года.")
                    }.padding()
                    
                    HStack{
                        Text("3. Какие запчасти используются при ремонте?")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        Spacer()
                    }.padding()
                    HStack {
                        Text("Для каждой модели устройства есть полный список предоставляемых услуг, с описанием используемой запчасти и ее характеристик. Вы получите ровно ту запчасть которую заказали, отклонения в сторону снижения качества запчасти быть не может.")
                    }.padding()
                    
                    HStack{
                        Text("4. Как проводятся ремонтные работы?")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        Spacer()
                    }.padding()
                    HStack {
                        Text("Все очень просто - клиент выбирает необходимую услугу, если это работа которую мастер может выполнить на локации заказчика, есть возможность выбрать, провести работы у вас или с доставкой в  РЦ  (ремонтный центр) и привозом обратно уже готового девайса заказчику. Но есть ряд работ, которые невозможно произвести вне РЦ, такие услугу помечены, и при их заказе нет возможности выбрать вариант с ремонтом на локации заказчика.")
                    }.padding()
                    
                    HStack{
                        Text("5. Каков порядок проведения ремонтных работ?")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        Spacer()
                    }.padding()
                    HStack {
                        Text("Вы выбираете необходимую услугу, оформляете заказ, администратор назначает мастера или курьера в зависимости от выбранной услуги, в течении 15 минут сотрудник Remmember приезжаем к вам, приступает к выполнению работ, либо забирает устройство в РЦ, по выполнению работ статус меняется на (…) и устройство едет обратно к вам.")
                    }.padding()
                }
            }
            Spacer()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .preferredColorScheme(.light)
    }
}


struct Accnew : View {
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
            HStack(spacing: 15){
                
                WebImage(url: URL(string: "item.item_image"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width / 3.2)
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("item.item_name")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                    }
                    
                    Spacer(minLength: 0)
                    
                }
                .padding()
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width - 30)
            .background(Color.white)
            .cornerRadius(25)
            // shadows..
            .shadow(color: Color.black.opacity(0.04), radius: 5, x: 5, y: 5)
            
            HStack(spacing: 10){
                Button(action: {
                }){
                    ZStack{
                        Rectangle()
                            .fill(Color("blue"))
                            .frame(width: 117,height: 43)
                            .cornerRadius(12)
                        HStack(spacing: 2){
                            Text("100000")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("₽")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                }
                
            }
            .padding(.trailing,-90)
            .padding(.top,99)
        })
    }
}


struct Acc_Previews: PreviewProvider {
    static var previews: some View {
        Accnew()
    }
}

