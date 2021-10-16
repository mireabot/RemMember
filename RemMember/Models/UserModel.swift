//
//  UserModel.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseFirestoreSwift


struct UserModel : Codable, Hashable {
    @DocumentID var id: String?
    var user_name : String?
    var user_phone: String?
    var user_id : String?
    var user_bonuses : Int?
    var user_orders : Int?
    var current_adress: String?
    var ref_code: String?
}


struct UserAdresses : Codable, Hashable {
    var street : String?
    var house : String?
    var apt : String?
    var floor : String?
    var pad : String?
}

struct UserPhones : Codable , Hashable {
    var phone_name : String
}
extension UserModel {
    static let empty = UserModel(id: "", user_name: "", user_phone: "", user_id: "", user_bonuses: 0,user_orders : 0,current_adress: "",ref_code: "@MTA")
    static let full = UserModel(id: "id", user_name: "name", user_phone: "1111", user_id: "id", user_bonuses: 100,user_orders: 1,current_adress: "street",ref_code: "")
}

