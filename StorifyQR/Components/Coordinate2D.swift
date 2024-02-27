//
//  Coordinate2D.swift
//  StorifyQR
//
//  Created by Maks Winters on 08.01.2024.
//

import Foundation
import MapKit

struct Coordinate2D: Codable {
    let latitude: Double
    let longitude: Double
    
    func getCLLocation() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
