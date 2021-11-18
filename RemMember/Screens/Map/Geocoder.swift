//
//  Geocoder.swift
//  RemMember
//
//  Created by Максим Данько on 18.11.2021.
//

import Foundation
import CoreLocation
import Combine

final class Geocoder {
    
    private let geocoder = CLGeocoder()
        
    func geocodeAddress(_ address: String) -> AnyPublisher<[Placemark], CLError> {
        return Future<[Placemark], CLError> { [weak self] completion in
            guard let self = self else { return }
            self.geocoder.geocodeAddressString(address) { placemarks, error in
                if let error = error as? CLError {
                    completion(.failure(error))
                    return
                }
                let placemarks = placemarks?.compactMap({ $0.placemark }) ?? []
                completion(.success(placemarks))
            }
        }.eraseToAnyPublisher()
    }
    
    func reverseLocationCoordinate(_ locationCoordinate: CLLocationCoordinate2D) -> AnyPublisher<[Placemark], CLError> {
        let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        return reverseLocation(location)
    }
    
    func reverseLocation(_ location: CLLocation) -> AnyPublisher<[Placemark], CLError> {
        return Future<[Placemark], CLError> { [weak self] completion in
            guard let self = self else { return }
            self.geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ru")) { placemarks, error in
                if let error = error as? CLError {
                    completion(.failure(error))
                }
                if let placemarks = placemarks?.compactMap({ $0.placemark }) {
                    completion(.success(placemarks))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}
