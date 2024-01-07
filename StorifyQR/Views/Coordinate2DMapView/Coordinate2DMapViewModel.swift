//
//  Coordinate2DMapViewModel.swift
//  StorifyQR
//
//  Created by Maks Winters on 07.01.2024.
//

import Foundation
import SwiftUI
import MapKit

@Observable
final class Coordinate2DMapViewModel {
    var rawLocation: CLLocationCoordinate2D
    var mapRegionPosition: MapCameraPosition
    
    init(coordinate2D: Coordinate2D) {
        let clLocation = CLLocationCoordinate2D(latitude: coordinate2D.latitude, longitude: coordinate2D.longitude)
        self.rawLocation = clLocation
        self.mapRegionPosition = .region(MKCoordinateRegion(center: clLocation, span: MapDetails.defaultSpan))
    }
}
