//
//  Coordinate2D.swift
//  StorifyQR
//
//  Created by Maks Winters on 08.01.2024.
//

import Foundation

struct Coordinate2D: Codable {
    let latitude: Double
    let longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
