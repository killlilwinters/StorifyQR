//
//  LocationGeocoder.swift
//  StorifyQR
//
//  Created by Maks Winters on 03.02.2024.
//

import Foundation
import MapKit

struct LocationGeocoder {
    func getLocationName(rawLocation: CLLocationCoordinate2D, completionHandler: @escaping (String) -> Void) {
        let lastLocation = CLLocation(latitude: rawLocation.latitude, longitude: rawLocation.longitude)
            let geocoder = CLGeocoder()
                
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                    let country = placemarks?[0].country
                    let city = placemarks?[0].locality
                    completionHandler("\(city ?? "area"), \(country ?? "Unknown")")
            })
    }
}
