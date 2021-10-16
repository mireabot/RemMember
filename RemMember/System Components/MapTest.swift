//
//  MapTest.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import MapKit
import CoreGraphics

extension CLLocationManager {
    func isInsideFence(points: Binding<[CGPoint]>, locations: Binding<[MKMapPoint]>, map: MKMapView) -> Bool {
        let coor = self.location?.coordinate ?? nil
        if coor != nil && locations.wrappedValue.count > 0 {
            let polygon = MKPolygon(coordinates: locations.wrappedValue.map({$0.coordinate}), count: locations.wrappedValue.count)
            return polygon.containsCoor(coor: coor!)
        }
        else {
            return false
        }
    }
}

extension MKPolygon {
    func containsCoor(coor: CLLocationCoordinate2D) -> Bool {
        let polygonRenderer = MKPolygonRenderer(polygon: self)
        let currentMapPoint: MKMapPoint = MKMapPoint(coor)
        let polygonViewPoint: CGPoint = polygonRenderer.point(for: currentMapPoint)
        if polygonRenderer.path == nil {
          return false
        }else{
          return polygonRenderer.path.contains(polygonViewPoint)
        }
    }
}


struct MapButton: View {
    
    var title: String
    var icon: String
    var action: ()->Void
    
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            HStack (spacing: 8) {
                Text(title).foregroundColor(.primary)
                Image(systemName: icon)
                .resizable()
                .frame(width:20, height:22.5, alignment: .center)
                .foregroundColor(.primary)
            }
            .padding(15)
        }.background(
            Color(.systemBackground)
                .opacity(0.3)
                .clipShape(Capsule())
        )
        .padding(15)
    }
}


struct PointView: View {
    
    @Binding var points: [CGPoint]
    @Binding var locations: [MKMapPoint]
    @Binding var map: MKMapView
    
    var body: some View {
        ForEach(0..<self.points.count, id: \.self) { point in
            ZStack {
                Color.red
                    .frame(width:50, height:50, alignment: .center)
                    .clipShape(Circle())
                Image(systemName: "\(point+1).circle")
                    .resizable()
                    .frame(width:40, height:40, alignment: .center)
                    .foregroundColor(.white)
                    
            }.position(x: self.points[point].x, y: self.points[point].y)
            .gesture(DragGesture().onChanged({ value in
                self.points[point] = value.location
                self.locations[point] = MKMapPoint(  self.map.convert(value.location, toCoordinateFrom: self.map)  )
            }))
            .onLongPressGesture {
                self.points.remove(at: point)
                self.locations.remove(at: point)
            }
            .onTapGesture (count: 2) {
                self.points.remove(at: point)
                self.locations.remove(at: point)
            }
        }
    }
    
    
}

struct PathView: View {
    
    @Binding var points: [CGPoint]
    
    var body: some View {
        ZStack (alignment: .center) {
            if self.points.count >= 2 {
                Path { path in
                    path.move(to: self.points.first!)
                    for pnt in 1..<self.points.count {
                        path.addLine(to: points[pnt])
                    }
                }
                .fill(Color.green.opacity(0.4))
                
                Path { path in
                    path.move(to: self.points.first!)
                    for pnt in 1..<self.points.count {
                        path.addLine(to: points[pnt])
                        if pnt == self.points.count - 1 {
                            path.addLine(to: points[0])
                        }
                    }
                }
                .stroke(Color.green, lineWidth: 3)
            }
        }
    }
    
    
}

struct PointTapView : View {
    @Binding var points:[CGPoint]
    @Binding var canPlot: Bool
    @Binding var locations: [MKMapPoint]
    @Binding var map: MKMapView
    
    var body: some View {
        ZStack (alignment: .topTrailing) {
            if self.canPlot {
                ZStack(alignment: .topLeading) {
                    Background { location in
                        if self.canPlot && self.points.count < 50 {
                            self.points.append(CGPoint(x: location.x + 25, y: location.y + 25))
                            let newMP = MKMapPoint( self.map.convert(location, toCoordinateFrom: self.map) )
                            self.locations.append(newMP)
                        }
                    }
                    PathView(points: self.$points)
                    PointView(points: self.$points, locations: self.$locations, map: self.$map)
                }
                MapButton(title: "Undo Point", icon: "arrow.counterclockwise") {
                    self.points = self.points.dropLast()
                    self.locations = self.locations.dropLast()
                    NotificationCenter.default.post(name: NSNotification.Name("newNotification"), object: nil)
                }
            }
            else {
                ZStack {
                    if self.points.count > 0 {
                        PathView(points: self.$points)
                    }
                    PointView(points: self.$points, locations: self.$locations, map: self.$map)
                }.opacity(0.3)
            }
        }
    }
}


struct Background : UIViewRepresentable {
    var tappedCallback: ((CGPoint) -> Void)

    func makeUIView(context: UIViewRepresentableContext<Background>) -> UIView {
        let v = UIView(frame: .zero)
        let gesture = UITapGestureRecognizer(target: context.coordinator,
                                             action: #selector(Coordinator.tapped))
        v.addGestureRecognizer(gesture)
        return v
    }

    class Coordinator: NSObject {
        var tappedCallback: ((CGPoint) -> Void)
        init(tappedCallback: @escaping ((CGPoint) -> Void)) {
            self.tappedCallback = tappedCallback
        }
        @objc func tapped(gesture:UITapGestureRecognizer) {
            let point = gesture.location(in: gesture.view)
            self.tappedCallback(point)
        }
    }

    func makeCoordinator() -> Background.Coordinator {
        return Coordinator(tappedCallback:self.tappedCallback)
    }

    func updateUIView(_ uiView: UIView,
                       context: UIViewRepresentableContext<Background>) {
    }

}

struct ExampleView: View {
    
    @State var geofencing: Bool = false
    @State var points:[CGPoint] = [CGPoint(x: 55.735885, y: 37.587015),CGPoint(x: 55.734828, y: 37.585443)]
    @State var locations: [MKMapPoint] = []
    @State var inGeofence: Bool = false
    
    var body: some View {
        
        ZStack {
            
            VStack {
                ForEach(0..<self.locations.count, id: \.self) { loc in
                    HStack {
                        ZStack {
                            Color.red
                                .frame(width:50, height:50, alignment: .center)
                                .clipShape(Circle())
                            Image(systemName: "\(loc+1).circle")
                                .resizable()
                                .frame(width:40, height:40, alignment: .center)
                                .foregroundColor(.white)
                                
                        }
                        VStack {
                            Text("latitude: \(self.locations[loc].coordinate.latitude)")
                            Text("longitude: \(self.locations[loc].coordinate.longitude)")
                        }
                    }
                    
                }
                MapButton(title: "Select Geofence", icon: "map") {
                    self.geofencing.toggle()
                }
                
            }.opacity(self.geofencing ? 0:1)
            
            SwiftUIPolygonGeofence(show: self.$geofencing, points: self.$points, locations: self.$locations).opacity(self.geofencing ? 1:0)
        
        }
        
    }
}


struct SwiftUIPolygonGeofence: View {
    @Binding var show: Bool
    @State var alert = false
    @State var canPlot = true
    @State var canDrag = false
    @Binding var points: [CGPoint]
    @Binding var locations: [MKMapPoint]
    @State var locManager: CLLocationManager = CLLocationManager()
    @State var map = MKMapView()
    
    var body: some View {

        ZStack (alignment: .bottom) {
            ZStack (alignment: .topLeading) {
                ZStack {
                    GeoFenceMapView(alert: $alert, map: self.$map, locManager: self.$locManager, locations: self.$locations)
                        
                    PointTapView(points: self.$points, canPlot: self.$canPlot, locations: self.$locations, map: self.$map)
                }
                MapButton(title: self.canPlot ? "Move Map":"Plot Points", icon: self.canPlot ? "map":"skew") {
                    self.canPlot.toggle()
                }
            }
            HStack {
                MapButton(title: self.locManager.isInsideFence(points: self.$points, locations: self.$locations, map: self.map) ? "Inside":"Outside", icon: self.locManager.isInsideFence(points: self.$points, locations: self.$locations, map: self.map) ? "checkmark":"xmark") {}
                MapButton(title: "Done", icon: "checkmark") {
                    print("📍 = \(self.locations.count)")
                    if self.locManager.isInsideFence(points: self.$points, locations: self.$locations, map: self.map) {
                        print("✅ user inside")
                    } else {
                        print("❌ not inside")
                    }
                    self.show.toggle()
                }
            }
        }
    }
}





struct GeoFenceMapView : UIViewRepresentable {

    @Binding var alert : Bool
    @Binding var map: MKMapView
    @Binding var locManager: CLLocationManager
    @Binding var locations: [MKMapPoint]

    func makeCoordinator() -> GeoFenceMapView.Coordinator {
        
        return Coordinator(parent1: self, locations: self.$locations)
    }

    func makeUIView(context: UIViewRepresentableContext<GeoFenceMapView>) -> MKMapView {


        let center = CLLocationCoordinate2D(latitude: 13.086, longitude: 80.2707)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.map.region = region
        self.map.showsUserLocation = true
        self.map.showsScale = true
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locManager.allowsBackgroundLocationUpdates = true
        self.locManager.pausesLocationUpdatesAutomatically = false
        self.locManager.requestWhenInUseAuthorization()
        self.locManager.delegate = context.coordinator
        self.locManager.startUpdatingLocation()
        
        return self.map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<GeoFenceMapView>) {}

    
    
    
    class Coordinator : NSObject,CLLocationManagerDelegate, MKMapViewDelegate {

        var parent : GeoFenceMapView
        var regionSet = false
        @Binding var locations: [MKMapPoint]

        init(parent1 : GeoFenceMapView, locations: Binding<[MKMapPoint]>) {
            parent = parent1
            _locations = locations
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

            if status == .denied{
                parent.alert.toggle()
            }
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            if let center: CLLocation = locations.last {
                if !self.regionSet {
                    self.parent.map.region = MKCoordinateRegion(center: center.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                    self.regionSet = true
                }
            }
        }
    }
}



