//
//  MapConstructor.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation
import Combine

struct MapView : UIViewRepresentable {
    
    func makeCoordinator() -> MapView.Coordinator {
        
        return MapView.Coordinator(parent1: self)
    }
    @Binding var title : String
    @Binding var manager : CLLocationManager
    @Binding var subtitle : String
    let map = MKMapView()
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) ->  MKMapView {
        
        let map = MKMapView()
        let coordinate = CLLocationCoordinate2D(latitude: manager.location?.coordinate.latitude ?? 0.0, longitude: manager.location?.coordinate.longitude ?? 0.0)
        map.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        map.delegate = context.coordinator
        
        map.addAnnotation(annotation)
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
    }
    class Coordinator: NSObject , MKMapViewDelegate, CLLocationManagerDelegate {
        
        var parent : MapView
        init(parent1: MapView) {
            parent = parent1
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin.isDraggable = true
            pin.pinTintColor = UIColor(named: "blue")
            pin.animatesDrop = true
            
            return pin
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)){ (places, err) in
                
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                
                self.parent.title = (places?.first?.name ?? places?.first?.postalCode)!
                self.parent.subtitle = (places?.first?.locality ?? places?.first?.country ?? "None")
            }
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let location = locations.last
            //            let point = MKPointAnnotation()
            
            
            let georeader = CLGeocoder()
            georeader.reverseGeocodeLocation(location!) { (places, err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }
            }
        }
    }
}

