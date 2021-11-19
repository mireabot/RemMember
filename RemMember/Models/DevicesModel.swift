//
//  DevicesModel.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI

struct Devices : Identifiable {
    var id = UUID().uuidString
    var title : String
    var active : Bool
}

var devices : [Devices] = [
    
    Devices(title: "iPhone 12 Pro Max", active: false),
    Devices(title: "iPhone 12 Pro", active: false),
    Devices(title: "iPhone 12 Mini",  active: false),
    Devices(title: "iPhone 12", active: false),
    Devices(title: "iPhone 11 Pro Max", active: false),
    Devices(title: "iPhone 11 Pro", active: false),
    Devices(title: "iPhone 11", active: false),
    Devices(title: "iPhone XS Max", active: false),
    Devices(title: "iPhone XS", active: false),
    Devices(title: "iPhone XR", active: false),
    Devices(title: "iPhone SE (2nd Gen)", active: false),
    Devices(title: "iPhone X", active: false),
    Devices(title: "iPhone 8 Plus", active: false),
    Devices(title: "iPhone 8", active: false),
    Devices(title: "iPhone 7 Plus", active: false),
    Devices(title: "iPhone 7", active: false),
    Devices(title: "iPhone 6s Plus", active: false),
    Devices(title: "iPhone 6s", active: false),
    Devices(title: "iPhone 6 Plus", active: false),
    Devices(title: "iPhone 6", active: false),
    Devices(title: "iPhone SE", active: false),
    Devices(title: "iPhone 5s", active: false)
]


struct DeviceView: View {
    var item : Devices
    @State var tapped = false
    @State var isSmallDevice = UIScreen.main.bounds.height < 750
    var body: some View {
            VStack{
                HStack{
                    Text(item.title)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Spacer()
                }.padding()
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: 103)
            .background(Color("blue"))
            .cornerRadius(20)
    }
}

struct Devicee_Previews: PreviewProvider {
    static var previews: some View {
        DeviceView(item: Devices(title: "iPhone 10", active: false))
    }
}

