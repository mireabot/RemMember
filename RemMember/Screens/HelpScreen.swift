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
                Text("Помощь")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
                
            }
            .padding()
            
            Spacer()
            
            VStack(alignment: .leading,spacing: 20){
                Text("Остались вопросы по сервису?")
                    .fontWeight(.semibold)
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                Button(action: {
                    let telephone = "tel://"
                        let formattedString =  telephone + "495-649-6886"
                        guard let url = URL(string: formattedString) else { return }
                        UIApplication.shared.open(url)
                }){
                    HStack {
                        Image("phone")
                            .frame(width: 20, height: 20)
                        Text("+7 (495) 649 6886")
                    }
                }
                Button(action: {
                    UIApplication.shared.open(botURL!)
                }){
                    HStack {
                        Image("paperplane_blue")
                            .frame(width: 20, height: 20)
                        Text("@modmacru")
                    }
                }
            }
            
            Spacer()
        }.preferredColorScheme(.light)
    }
}


struct HelpPage_Previews: PreviewProvider {
    static var previews: some View {
        HelpPage()
    }
}

