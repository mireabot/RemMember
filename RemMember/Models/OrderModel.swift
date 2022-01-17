//
//  OrderModel.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

//struct Order : Identifiable {
//    var id : String
//    var number : NSNumber
//    var status : String
//    var client_name : String
//    var client_device : String
//    var order_master : String
//    var client_phone : String
//    var client_adress : String
//    var client_id : String
//}

struct OrderTest : Codable, Hashable {
    @DocumentID var id: String?
    var order_number : Int?
    var status : String?
    var client_name : String?
    var client_device : String?
    var order_master : String?
    var client_phone : String?
    var client_adress : String?
    var client_ID : String?
    var total_cost : String?
    var master_phone : String?
    var payment_type : String?
    var repair_location : String?
    var order: [OrderDetails]
    var active: Bool?
    var date: Date
}

struct OrderDetails : Hashable, Codable {
    var item_cost : Int
    var item_name : String
}
extension OrderTest {
    static let empty = OrderTest(id: "", order_number: 0, status: "", client_name: "", client_device: "", order_master: "", client_phone: "", client_adress: "", client_ID: "", total_cost: "", master_phone: "", payment_type: "", repair_location: "", order: [],active: false,date: Date())
    static let sample = OrderTest(id: "1", order_number: 1, status: "q", client_name: "q", client_device: "q", order_master: "q", client_phone: "q", client_adress: "q", client_ID: "q", total_cost: "32500", master_phone: "Ivan", payment_type: "e", repair_location: "Office", order: [OrderDetails(item_cost: 32500, item_name: "Ремонт"),OrderDetails(item_cost: 32500, item_name: "Ремонт")],active: true,date: Date())
}


struct Orderhistory : Codable , Identifiable {
    @DocumentID var id: String?
    var order_number: Int?
    var client_ID: String?
    var client_adress: String?
    var status : String?
    var total_cost: String?
    var order: [OrderDetails]
    var date: Date
}

