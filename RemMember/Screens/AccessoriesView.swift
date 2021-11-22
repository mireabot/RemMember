//
//  AccessoriesView.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct AccessoriesView : View {
    var item : Accessories
    var body: some View {
        HStack(spacing: 15){
            HStack{
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text(item.item_name)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    Text(item.item_body)
                        .foregroundColor(.black.opacity(0.4))
                    
                    HStack(spacing: 2){
                        Text(getPrice(value: Float(truncating: item.item_cost)))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("blue"))
                        Text("₽")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("blue"))
                    }
                }
                
                Spacer(minLength: 0)
                
            }
            .padding()
            
            WebImage(url: URL(string: item.item_image))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 90, height: 141)
        .background(Color.white)
        .cornerRadius(10)
        // shadows..
        .shadow(color: Color.black.opacity(0.01), radius: 5, x: 5, y: 5)
    }
    func getPrice(value: Float)->String{
        
        let format = NumberFormatter()
        
        return format.string(from: NSNumber(value: value)) ?? ""
    }
}

struct AccessoriesViewDetails : View {
    var item : Accessories
    @StateObject var Homemodel : HomeViewModel
    var body: some View {
        HStack(spacing: 15){
            HStack{
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text(item.item_name)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    Text(item.item_body)
                        .foregroundColor(.black.opacity(0.4))
                    
                    HStack(spacing: 2){
                        Text(getPrice(value: Float(truncating: item.item_cost)))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("blue"))
                        Text("₽")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("blue"))
                    }
                }
                
                Spacer(minLength: 0)
                
            }
            .padding()
            
            WebImage(url: URL(string: item.item_image))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 90, height: 141)
        .background(Color.white)
        .cornerRadius(10)
        // shadows..
        .shadow(color: Color.black.opacity(0.01), radius: 5, x: 5, y: 5)
    }
    func getPrice(value: Float)->String{
        
        let format = NumberFormatter()
        
        return format.string(from: NSNumber(value: value)) ?? ""
    }
}
struct AccessoriesViewForAll : View {
    var item : Accessories
    var body: some View {
        HStack(spacing: 5){
            
            WebImage(url: URL(string: item.item_image))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            HStack{
                
                    
                VStack(alignment: .leading, spacing: 10) {
                    Text(item.item_name)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    HStack(spacing: 2){
                        Text(getPrice(value: Float(truncating: item.item_cost)))
                            .fontWeight(.bold)
                            .foregroundColor(Color("blue"))
                        Text("₽")
                            .fontWeight(.bold)
                            .foregroundColor(Color("blue"))
                    }
                }
                
                Spacer(minLength: 0)
                
            }
            .padding()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(10)
        // shadows..
        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 5, y: 5)
    }
    func getPrice(value: Float)->String{
        
        let format = NumberFormatter()
        
        return format.string(from: NSNumber(value: value)) ?? ""
    }
}
struct CustomCornerAc : Shape {
    
    var corners : UIRectCorner
    var size : CGFloat
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: size, height: size))
        
        return Path(path.cgPath)
    }
}

