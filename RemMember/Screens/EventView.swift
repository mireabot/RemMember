//
//  EventView.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct Event_View : View {
    var event : Event
    var body: some View {
        if event.event_name == "w" && event.event_details == "w" && event.event_image == "w" && event.event_new_details == 0 {
            
        }
        else {
            ZStack {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(event.event_name ?? "")")
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .bold))
                        Text("до \(event.event_details ?? "")")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(#colorLiteral(red: 0.8089704949, green: 0.8089704949, blue: 0.8089704949, alpha: 1)))
                        HStack(spacing: 15){
                            Text("Новая цена: \(event.event_new_details ?? 0) ₽")
                                .foregroundColor(.black)
                                .font(.system(size: 16, weight: .medium))
                        }
                        
                    }
                    .padding(.leading, 40)
                    Spacer()
                    WebImage(url: URL(string: event.event_image ?? ""))
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            }
            .frame(width: 345, height: 141)
            .background(Color.white)
            .cornerRadius(10)
            // shadows..
            .shadow(color: Color("blue").opacity(0.1), radius: 5, x: 5, y: 5)
            
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
                    Text("Действует до \(event.event_details ?? "")")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(#colorLiteral(red: 0.8089704949, green: 0.8089704949, blue: 0.8089704949, alpha: 1)))
                }
                Spacer()
            }.padding()
            
            Spacer()
            
            Button(action: {
                self.present.wrappedValue.dismiss()
                Homemodel.addToCartTest(item: Accessories(id: event.id ?? "", item_name: event.event_name ?? "", item_image: event.event_image ?? "", item_cost: NSNumber(value: event.event_new_details ?? 0), item_body: ""))
            }){
                Text("\(event.event_new_details ?? 0) ₽")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .background(
                        Color("blue")
                    )
                    .cornerRadius(15)
            }.padding(.bottom, 10)
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
    func getPrice(value: Float)->String{
        
        let format = NumberFormatter()
        
        return format.string(from: NSNumber(value: value)) ?? ""
    }
}
