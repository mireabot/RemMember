# RemMember

Online repair service of Apple devices in Moscow, Russia. This project was created from scratch by myself

You can see some facts and samples below: 

# Design project

https://www.figma.com/file/ATRfaMHaZ8VK9EKyiVg76E/RemMember?node-id=0%3A1

# Project cover and code sample

![Alt text](https://dim.mcusercontent.com/cs/4498468663ace51c5029b39d4/images/5bc50f27-a130-23bb-a510-9de0076fb008.png?w=608&dpr=2)

```swift
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
```
