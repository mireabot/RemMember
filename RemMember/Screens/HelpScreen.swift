//
//  HelpScreen.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI


struct HelpPage : View {
    let botURL = URL.init(string: "https://t.me/modmacru")
    @Environment(\.presentationMode) var present
    var body: some View {
        VStack {
            HStack(spacing: 25){
                Text("Помощь")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
                
            }
            .padding()
            
            
            VStack{
                
                
                HStack(spacing: 15){
                    
                    Image("tg")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(12)
                        .background(
                            
                            Color.white
                                .clipShape(Circle())
                        )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("@modmacru")
                            .fontWeight(.bold)
                        
                        Text("Всегда на связи")
                            .font(.caption2.bold())
                            .foregroundColor(.gray)
                    }
                    
                    Spacer(minLength: 10)
                    
                    Button(action: {
                        UIApplication.shared.open(botURL!)
                    }) {
                        Image(systemName: "message")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(18)
            
            Spacer()
            
            VStack {
                Text("Остались вопросы по сервису?")
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.4))
                Button(action: {
                    let telephone = "tel://"
                    let formattedString =  telephone + "7-495-649-6886"
                    guard let url = URL(string: formattedString) else { return }
                    UIApplication.shared.open(url)
                }){
                    ZStack{
                        Rectangle()
                            .fill(Color("blue"))
                            .frame(width: UIScreen.main.bounds.width - 50,height: 56)
                            .cornerRadius(12)
                            .shadow(color: Color.gray.opacity(0.04), radius: 1, x: 5, y: 5)
                            .shadow(color: Color.gray.opacity(0.04), radius: 1, x: -5, y: -5)
                        HStack(spacing: 2){
                            Text("Позвонить")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .preferredColorScheme(.light)
    }
}


struct HelpPage_Previews: PreviewProvider {
    static var previews: some View {
        HelpPage()
    }
}

