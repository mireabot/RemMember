//
//  Date.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 26.01.2022.
//

import Foundation
import SwiftUI


extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
