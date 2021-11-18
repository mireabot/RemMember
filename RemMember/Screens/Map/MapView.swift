//
//  MapView.swift
//  RemMember
//
//  Created by Максим Данько on 18.11.2021.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation
import Combine
import iTextField

enum MapFolowState {
    case afterRegistration
    case addAddress
}

struct Map: View {
    
    @StateObject var viewModel = MapViewModel()
    
    @State var presentedSearchAddress = false
    
    @AppStorage("first_lanch") var lanch = false
    @AppStorage("log_Status") var status = false
    
    @Environment(\.presentationMode) var present
 
    private let flowState: MapFolowState
    
    init(flowState: MapFolowState) {
        self.flowState = flowState
    }
    
    var body: some View {
        ZStack {
            map
            VStack {
                if !presentedSearchAddress {
                    if !viewModel.coordinateInPolygon  {
                        Text("К сожалению не работаем в данном районе")
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                            .padding(.bottom, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(red: 7 / 255, green: 197 / 255, blue: 252 / 255))
                            )
                    }
                    Spacer()
                }
                MapBottomSheet(isFullPresented: $presentedSearchAddress, comments: $viewModel.comments, searchedAddress: $viewModel.searchedAddress, animation: .default, onPress: onPressHandler()
                ).frame(maxHeight: presentedSearchAddress ? .infinity : 290)
                    .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
                    .transition(.move(edge: .top))
            }.ignoresSafeArea(.container, edges: .bottom)
        }.onAppear {
            if flowState == .afterRegistration {
                viewModel.createUser()
            }
        }.navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
    
    
    var map: some View {
        ZStack(content: {
            MapView(centerCoordinate: $viewModel.centerCoordinate, needUpdate: $viewModel.needUpdate, coordinateInPolygon: $viewModel.coordinateInPolygon)
                .ignoresSafeArea()
            Image("pin")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .offset(CGSize(width: 0, height: -40))
        }).ignoresSafeArea()
    }
    
    func onPressHandler() -> () -> Void {
        return {
            switch flowState {
            case .afterRegistration:
                UserDefaults.standard.setValue(self.viewModel.searchedAddress, forKey: "ClientStreet")
                UserDefaults.standard.setValue(self.viewModel.comments, forKey: "ClientComment")
                viewModel.addAddress(isCurrent: true)
                viewModel.setCurrentAddress()
                withAnimation{ status = true }
            case .addAddress:
                viewModel.addAddress(isCurrent: false)
                present.wrappedValue.dismiss()
            }
        }
    }
    
}

struct MapBottomInputView: View {
    
    @Binding var title: String
    
    let placeholder: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.06))
                .frame(height: 48)
                .cornerRadius(10)
            HStack {
                Text(title.isEmpty ? placeholder: title)
                    .fontWeight(.regular)
                    .foregroundColor(.black)
                    .lineLimit(1)
                Spacer()
            }.padding()
        }
    }
    
}

struct MapBottomButtonView: View {
        
    var didPress: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 7 / 255, green: 197 / 255, blue: 252 / 255))
                .frame(height: 48)
                .cornerRadius(10)
            HStack {
                Button(action: didPress) {
                    Text("Добавить адрес")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }.padding()
        }
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        Map(flowState: .addAddress)
    }
}

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var needUpdate: Bool
    @Binding var coordinateInPolygon: Bool
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.overrideUserInterfaceStyle = .light
        mapView.delegate = context.coordinator
        let coordinates = [
            CLLocationCoordinate2D(latitude: 55.758191, longitude: 37.585421),
            CLLocationCoordinate2D(latitude: 55.753906, longitude: 37.601453),
            CLLocationCoordinate2D(latitude: 55.745427, longitude: 37.604825),
            CLLocationCoordinate2D(latitude: 55.750628, longitude: 37.654944),
            CLLocationCoordinate2D(latitude: 55.775535, longitude: 37.653092),
            CLLocationCoordinate2D(latitude: 55.772401, longitude: 37.608203)
        ]
        mapView.setCamera(MKMapCamera(lookingAtCenter: centerCoordinate, fromDistance: 2000, pitch: 0, heading: 0), animated: true)
        let polygon = MKPolygon(coordinates: coordinates, count: 6)
        mapView.addOverlay(polygon)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        if needUpdate {
            needUpdate = false
            uiView.setCamera(MKMapCamera(lookingAtCenter: centerCoordinate, fromDistance: 2000, pitch: 0, heading: 0), animated: true)
        }
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        return Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        
        let parent: MapView
        
        init(parent: MapView) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.centerCoordinate = mapView.centerCoordinate
            
            let coordinates = [
                CLLocationCoordinate2D(latitude: 55.758191, longitude: 37.585421),
                CLLocationCoordinate2D(latitude: 55.753906, longitude: 37.601453),
                CLLocationCoordinate2D(latitude: 55.745427, longitude: 37.604825),
                CLLocationCoordinate2D(latitude: 55.750628, longitude: 37.654944),
                CLLocationCoordinate2D(latitude: 55.775535, longitude: 37.653092),
                CLLocationCoordinate2D(latitude: 55.772401, longitude: 37.608203)
            ]
            let polygon = MKPolygon(coordinates: coordinates, count: 6)
            let polygonRenderer = MKPolygonRenderer(polygon: polygon)
            let mapPoint: MKMapPoint = MKMapPoint(mapView.centerCoordinate)
            let polygonViewPoint: CGPoint = polygonRenderer.point(for: mapPoint)
            
            parent.coordinateInPolygon = polygonRenderer.path.contains(polygonViewPoint)
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.lineWidth = 1
            polygonView.strokeColor = UIColor.blue.withAlphaComponent(0.8)
            polygonView.fillColor = UIColor.blue.withAlphaComponent(0.5)
            return polygonView
        }
    }
}
