//
//  AccessoriesModel.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI


struct Accessories : Identifiable {
    var id : String
    var item_name : String
    var item_image : String
    var item_cost : NSNumber
    var item_body: String
    var isAdded: Bool = false
}
