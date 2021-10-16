//
//  ItemView.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ItemView: View {
    @StateObject var Homemodel = HomeViewModel()
    var item: iPhones
    @State var showDetail = false
    var body: some View {
        
        VStack{
            HStack(spacing: 70){
                WebImage(url: URL(string: item.item_image))
                    .resizable()
                    .frame(width: 59,height: 109)
                
                VStack(spacing: 40){
                    Text(item.item_name)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                    Text("1")
                        .foregroundColor(.white)
                }
                .frame(width: UIScreen.main.bounds.width - 250, alignment: .leading)
                Spacer()
            }.padding()
            Rectangle()
                .fill(Color.gray.opacity(0.4))
                .frame(width: UIScreen.main.bounds.width - 30,height: 1)
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: 150)
    }
    func getPrice(value: Float)->String{
        
        let format = NumberFormatter()
        
        return format.string(from: NSNumber(value: value)) ?? ""
    }
}

