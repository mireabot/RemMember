//
//  Alerts.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import SwiftUI

// Уведомление при регистрации

struct AlertView: View {
    var msg: String
    @Binding var show: Bool
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15, content: {
            Text("Message")
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            Text(msg)
                .foregroundColor(.gray)
            
            Button(action: {
                // closing popup...
                show.toggle()
            }, label: {
                Text("Close")
                    .foregroundColor(.black)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
                    .background(Color("yellow"))
                    .cornerRadius(15)
            })
            
            // centering the button
            .frame(alignment: .center)
        })
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal,25)
        
        // background dim...
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3).ignoresSafeArea())
    }
}

struct SFSymbolTogglestyle: ToggleStyle {
    
    var onSystemImageName: String = "checkmark.circle.fill"
    var offSystemImageName: String = "xmark.circle.fill"
    @Binding var tap : Bool
    static let backgroundColor = Color(.label)
    static let switchColor = Color(.systemBackground)
    
    func makeBody(configuration: Configuration) -> some View {
        
        HStack {
            
            configuration.label.font(.system(size: 16), weight: .medium)
            
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: 50, height: 30, alignment: .center)
                .overlay((
                    Image(systemName: configuration.isOn ? onSystemImageName : offSystemImageName)
                        .font(.system(size: 20))
                        .foregroundColor(configuration.isOn ? .white : SFSymbolTogglestyle.switchColor)
                        .padding(3)
                        .offset(x: configuration.isOn ? 10 : -10, y: 0)
                        .animation(.linear)
                ))
                .foregroundColor(configuration.isOn ? Color("blue") : SFSymbolTogglestyle.backgroundColor)
                .onTapGesture(perform: {
                    configuration.isOn.toggle()
                    self.tap.toggle()
                    print(tap)
                })
            
        }
        
    }
    
}

