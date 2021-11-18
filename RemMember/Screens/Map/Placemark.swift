//
//  Placemark.swift
//  RemMember
//
//  Created by Максим Данько on 18.11.2021.
//

import SwiftUI
import CoreLocation

struct Placemark: Identifiable {
    let id: String
    let name: String
    let location: CLLocationCoordinate2D
}


extension CLPlacemark {

    var placemark: Placemark? {
        guard let location = location, let name = name else { return nil }
        return Placemark(id: UUID().uuidString, name: name, location: location.coordinate)
    }

}

extension Placemark {

    static let empty: Placemark = {
       return Placemark(id: "", name: "", location: CLLocationCoordinate2D())
    }()

}

