//
//  EventView.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase


struct Event_View : View {
    var event : Event
    var body: some View {
        if event.event_name == "w" && event.event_details == "w" && event.event_image == "w" && event.event_new_details == "w" {
            
        }
        else {
            ZStack {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(event.event_name ?? "")")
                            .foregroundColor(.black)
                            .font(.system(size: 22, weight: .bold))
                        Text("до \(event.event_image ?? "")")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(#colorLiteral(red: 0.8089704949, green: 0.8089704949, blue: 0.8089704949, alpha: 1)))
                        HStack(spacing: 15){
                            Text("Новая цена: \(event.event_new_details ?? "") ₽")
                                .foregroundColor(.black)
                                .font(.system(size: 16, weight: .medium))
                        }
                        
                    }
                    .padding(.leading, 40)
                    Spacer()
                }
            }
            .frame(width: 325, height: 141)
            .background(Color.white)
            .cornerRadius(10)
            // shadows..
            .shadow(color: Color.black.opacity(0.01), radius: 5, x: 5, y: 5)
            
        }
    }
}


//struct Event_Previews: PreviewProvider {
//    static var previews: some View {
//        Event_View()
//    }
//}

struct EventDetailView : View {
    @Environment(\.presentationMode) var present
    @StateObject var Homemodel : HomeViewModel
    var event : Event
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
                
                Spacer()
                
            }
            .padding()
            HStack {
                VStack(alignment: .leading,spacing: 10) {
                    Text(event.event_name ?? "")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Text("Действует до \(event.event_image ?? "")")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(#colorLiteral(red: 0.8089704949, green: 0.8089704949, blue: 0.8089704949, alpha: 1)))
                }
                Spacer()
            }.padding()
            
            Spacer()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}
