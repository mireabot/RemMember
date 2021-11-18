//
//  MapViewModel.swift
//  RemMember
//
//  Created by Максим Данько on 18.11.2021.
//

import SwiftUI
import Combine
import CoreLocation

final class MapViewModel: NSObject, ObservableObject {
    
    @Published var centerCoordinate: CLLocationCoordinate2D = .zero
    @Published var coordinateInPolygon: Bool = false
    
    @Published var needUpdate = false
    
    @Published var searchedAddress = ""
    @Published var comments = ""
    
    private var cancellables : Set<AnyCancellable> = []
    
    private let geocoder = Geocoder()
    private let clientInfo = ClientInfo()
    private let userData = UserView()
    private let locationManager = CLLocationManager()
    
    private var isGeocodeAddress = false
    private var isReverseLocationCoordinate = false
    
    override init() {
        super.init()
        $searchedAddress.sink { _ in
            
        } receiveValue: { [weak self] address in
            guard let self = self else { return }
            
            if self.isReverseLocationCoordinate {
                self.isReverseLocationCoordinate = false
                return
            }
            
            self.geocoder.geocodeAddress(address).sink { _ in
                
            } receiveValue: { [weak self] placemarks in
                guard let self = self, let placemark = placemarks.first else { return }
                self.isGeocodeAddress = true
                self.centerCoordinate = placemark.location
                self.needUpdate = true
            }.store(in: &self.cancellables)

        }.store(in: &cancellables)
        
        $centerCoordinate.sink { [weak self] locaton in
            guard let self = self else { return }
            if self.isGeocodeAddress {
                self.isGeocodeAddress = false
                return
            }
            
            if self.isReverseLocationCoordinate {
                self.isReverseLocationCoordinate = false
                return
            }
            
            self.geocoder.reverseLocationCoordinate(locaton).sink { _ in
                
            } receiveValue: { [weak self] placemarks in
                guard let self = self, let placemark = placemarks.first else { return }
                self.isReverseLocationCoordinate = true
                self.centerCoordinate = placemark.location
                self.isReverseLocationCoordinate = true
                self.searchedAddress = placemark.name
            }.store(in: &self.cancellables)
        }.store(in: &cancellables)
        
        locationManager.delegate = self
        
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    func addAddress(isCurrent: Bool, onSuccess: (() -> Void)? = nil, onError: (() -> Void)? = nil) {
        guard coordinateInPolygon else { return }
        let address = AddressItem(address: searchedAddress, location: centerCoordinate)
        clientInfo.addAddress(address, comment: comments, isCurrent: isCurrent).sink { _ in
            onError?()
        } receiveValue: { result in
            onSuccess?()
        }.store(in: &cancellables)
    }
    
    
    func createUser() {
        userData.createUser(bonus: 0)
    }
    
    func setCurrentAddress(onSuccess: (() -> Void)? = nil, onError: (() -> Void)? = nil) {
        userData.setCurrentAdress(adress: searchedAddress)
    }
    
}

extension MapViewModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse else { return  }
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else { return }
        #if DEBUG
        print(error)
        #endif
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        needUpdate = true
        centerCoordinate = location.coordinate
    }
    
}

extension CLLocationCoordinate2D {
    
    static var zero: CLLocationCoordinate2D {
        return CLLocationCoordinate2D()
    }
    
}
