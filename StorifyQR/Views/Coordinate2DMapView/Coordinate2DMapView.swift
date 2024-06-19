//
//  Coordinate2DMapView.swift
//  StorifyQR
//
//  Created by Maks Winters on 07.01.2024.
//
// https://stackoverflow.com/a/60113557
//

import SwiftUI
import MapKit

struct Coordinate2DMapView: View {
    
    @State var locationName = "Unknown locaiton"
    let locationGeocoder = LocationGeocoder()
    
    var rawLocation: CLLocationCoordinate2D
    @State var mapRegionPosition: MapCameraPosition
    
    var body: some View {
        VStack {
            Text("Registered location:")
                .font(.system(.headline))
                .padding(.horizontal)
            Map(position: $mapRegionPosition) {
                Marker("Item's location", coordinate: rawLocation)
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .allowsHitTesting(false)
            LocationNameBar(locationName: locationName)
                .onAppear(perform: getLocationName)
        }
        .modifier(ContentPad())
        .padding(.horizontal)
    }
    
    func getLocationName() {
        locationGeocoder.getLocationName(rawLocation: rawLocation) { place in
            self.locationName = place
        }
    }
    
    init(coordinate2D: Coordinate2D) {
        let clLocation = CLLocationCoordinate2D(latitude: coordinate2D.latitude, longitude: coordinate2D.longitude)
        self.rawLocation = clLocation
        self.mapRegionPosition = .region(MKCoordinateRegion(center: clLocation, span: MapDetails.defaultSpan))
    }
    
}

#Preview {
    Coordinate2DMapView(coordinate2D: Coordinate2D(latitude: 8.000, longitude: 10.000))
}
