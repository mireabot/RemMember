//
//  EventModel.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift


struct Event : Codable, Hashable, Identifiable {
    
    @DocumentID var id : String?
    var event_name : String?
    var event_details : String?
    var event_image : String?
    var event_new_details : Int?
}

extension Event {
    static let empty = Event(id: "", event_name: "", event_details: "", event_image: "", event_new_details: 0)
    static let sample = Event(id: "", event_name: "", event_details: "", event_image: "", event_new_details: 0)
}
