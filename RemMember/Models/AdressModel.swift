//
//  AdressModel.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI


struct Adress_Model : Identifiable {
    
    var id: String
    var client_street: String
    var client_comment: String
    var client_id: String
    var is_current : Bool
}

