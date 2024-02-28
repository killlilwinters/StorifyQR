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
final class MapViewModel: LocationHandlerDelegate {
    let locationGeocoder = LocationGeocoder()

    var gpsLocation = MapDetails.defaultRegion
    var editingLocation: CLLocationCoordinate2D?
    var userCustomLocation: CLLocationCoordinate2D? { didSet {
        getLocationName()
    }}
    
    var finalLocation: CLLocationCoordinate2D {
        userCustomLocation ?? editingLocation ?? gpsLocation
    }
    var mapRegionPosition: MapCameraPosition = .region(MKCoordinateRegion(center: MapDetails.defaultRegion, span: MapDetails.defaultSpan))
    
    var isIncludingLocation = false
    var isLocationAvailable = false
    
    var showAlerts = false
    var isShowingAlert = false
    
    var alertMessage = ""
    
    var locationName = "Unknown location"
    
    var locationManager: LocationManager!
    
    init(editingLocation: Coordinate2D?) {
        if editingLocation != nil {
            self.editingLocation = editingLocation?.getCLLocation()
            self.isIncludingLocation = true
        }
        self.locationManager = LocationManager(delegate: self)
        self.locationManager.checkIfLocationServicesIsEnabled()
    }
    
    func didUpdateLocation() {
        gpsLocation = locationManager.getCurrentLocation() ?? MapDetails.defaultRegion
        mapRegionPosition = .region(MKCoordinateRegion(center: finalLocation, span: MapDetails.defaultSpan))
        isLocationAvailable = true
    }
    
    func didFailWithError(error: Error) {
        switch error {
        case LocationError.locationServicesDisabled:
            alertUser("Location services seem to be turned off.")
        case LocationError.locationRestricted:
            isIncludingLocation = false
            showAlerts ? alertUser("Tour location is restricted likely due to parental controls.") : nil
        case LocationError.locationDenied:
            isIncludingLocation = false
            showAlerts ? alertUser("You have denied location permission, you can re-enable it in settings") : nil
        case LocationError.unknownAuthorizationStatus:
            isIncludingLocation = false
            showAlerts ? alertUser("Unknown locationManager authrorization status, contact developer.") : nil
        case LocationError.locationNotAvailable:
            isIncludingLocation = false
            showAlerts ? alertUser("Location not available.") : nil
        default:
            break
        }
    }

    func getCurrentLocation() -> Coordinate2D? {
        isIncludingLocation ? finalLocation.toCoordinate2D() : nil
    }
    
    func getLocationName() {
        locationGeocoder.getLocationName(rawLocation: finalLocation) { place in
            self.locationName = place
        }
    }
    
    func alertUser(_ message: String) {
        alertMessage = message
        isShowingAlert = true
    }
    
    func resetLocation() {
        editingLocation = nil
        userCustomLocation = nil
        withAnimation {
            mapRegionPosition = .region(MKCoordinateRegion(center: finalLocation, span: MapDetails.defaultSpan))
        }
    }
    
}

