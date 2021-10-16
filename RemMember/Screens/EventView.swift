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
                        Text("\(event.event_name)")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        Text("\(event.event_image)")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(Color(#colorLiteral(red: 0.8089704949, green: 0.8089704949, blue: 0.8089704949, alpha: 1)))
                        HStack(spacing: 15){
                            Text("\(event.event_new_details) ₽")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                            ZStack {
                                Rectangle()
                                    .fill(Color.red)
                                    .frame(width: 50, height: 1)
                                Text("\(event.event_details) ₽")
                                    .foregroundColor(.black)
                            }
                        }
                        
                    }
                    .padding(.leading, 40)
                    Spacer()
                }
            }
            .frame(width: 335, height: 120)
            .background(Color.white)
            .cornerRadius(30)
            .shadow(color: Color.blue.opacity(0.2), radius: 5, x: 5, y: 5)
            
        }
    }
}


//struct Event_Previews: PreviewProvider {
//    static var previews: some View {
//        Event_View()
//    }
//}

