//
//  MapViewModel.swift
//  StorifyQR
//
//  Created by Maks Winters on 03.01.2024.
//

import MapKit
import SwiftUI

enum MapDetails {
    static let defaultRegion = CLLocationCoordinate2D(latitude: 8.7832, longitude: 124.5085)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
}

@Observable
final class MapViewModel: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    let locationGeocoder = LocationGeocoder()
    
    static let shared = MapViewModel()

    var rawLocation = MapDetails.defaultRegion
    var userCustomLocation: CLLocationCoordinate2D? { didSet {
        getLocationName()
    }}
    var finalLocation: CLLocationCoordinate2D {
        userCustomLocation ?? rawLocation
    }
    var mapRegionPosition: MapCameraPosition = .region(MKCoordinateRegion(center: MapDetails.defaultRegion, span: MapDetails.defaultSpan))
    
    var isIncludingLocation = false
    var isLocationAvailable = false
    
    var showAlerts = false
    var isShowingAlert = false
    
    var alertMessage = ""
    
    var locationName = "Unknown location"
    
    func getLocationName() {
        locationGeocoder.getLocationName(rawLocation: finalLocation) { place in
            self.locationName = place
        }
    }
    
    func checkIfLocationServicesIsEnabled() {
        DispatchQueue.global().async {
            guard CLLocationManager.locationServicesEnabled() else {
                self.alertUser("Location services seem to be turned off.")
                return
            }
        }
            self.locationManager = CLLocationManager()
            self.locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager!.delegate = self
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            isIncludingLocation = false
            showAlerts ? alertUser("Tour location is restricted likely due to parental controls.") : nil
        case .denied:
            isIncludingLocation = false
            showAlerts ? alertUser("You have denied location permission, you can re-enable it in settings") : nil
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            handleAuthorizedLocation()
        @unknown default:
            isIncludingLocation = false
            showAlerts ? alertUser("Unknown locationManager authrorization status, contact developer.") : nil
        }
    }
    
    private func handleAuthorizedLocation() {
        rawLocation = locationManager?.location?.coordinate ?? MapDetails.defaultRegion
        mapRegionPosition = .region(MKCoordinateRegion(center: rawLocation, span: MapDetails.defaultSpan))
        isLocationAvailable = true
    }
    
    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func getCurrentLocation() -> Coordinate2D? {
        if isIncludingLocation {
            let location = finalLocation
            return Coordinate2D(latitude: location.latitude, longitude: location.longitude)
        } else {
            return nil
        }
    }
    
    func alertUser(_ message: String) {
        alertMessage = message
        isShowingAlert = true
    }
    
    func resetLocation() {
        userCustomLocation = nil
        withAnimation {
            mapRegionPosition = .region(MKCoordinateRegion(center: finalLocation, span: MapDetails.defaultSpan))
        }
    }
    
}

