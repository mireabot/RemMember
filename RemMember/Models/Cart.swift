//
//  Cart.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI

struct Cart: Identifiable {
    
    var id = UUID().uuidString
    var item: iPhones
    var quantity: Int
}

struct CartAcc : Identifiable {
    
    var id = UUID().uuidString
    var accessori: Accessories
}

