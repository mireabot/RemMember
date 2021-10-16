//
//  MainItem.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct iPhones: Identifiable {
    
    var id: String
    var item_name: String
    var item_cost: NSNumber
    var item_details: String
    var item_image: String
    var item_time: String
    var item_plus_time : String
    var item_type : String
    // to identify whether it is added to cart...
    var isAdded: Bool = false
}

struct AddsView : View {
    var adds : iPhones
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            ZStack {
                Rectangle()
                    .fill(Color.black.opacity(0.08))
                    .cornerRadius(12)
                    .frame(width: 138, height: 119)
                
                WebImage(url: URL(string: adds.item_image))
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            
            Text(adds.item_name)
                .foregroundColor(.black)
            Text("\(adds.item_cost) ₽")
                .fontWeight(.bold)
                .font(.system(size: 16))
                .foregroundColor(.black)
        }
    }
}
