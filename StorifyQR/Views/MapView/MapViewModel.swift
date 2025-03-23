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
final class MapViewModel {
    
    // MARK: - Location
    var locationManager: LocationManager!
    let locationGeocoder = LocationGeocoder()
    
    var isIncludingLocation: Bool
    var isLocationAvailable = false

    var gpsLocation = MapDetails.defaultRegion
    var editingLocation: CLLocationCoordinate2D?
    var userCustomLocation: CLLocationCoordinate2D? { didSet {
        getLocationName()
    }}
    
    var finalLocation: CLLocationCoordinate2D {
        userCustomLocation ?? editingLocation ?? gpsLocation
    }
    var mapRegionPosition: MapCameraPosition = .region(MKCoordinateRegion(center: MapDetails.defaultRegion, span: MapDetails.defaultSpan))
    
    var locationName = "Unknown location"
    
    // MARK: - Alert
    var showAlerts = false
    var isShowingAlert = false
    var alertMessage = ""
    
    // MARK: - Initializer
    init(editingLocation: Coordinate2D?, isIncludingLocation: Bool = false) {
        print("Initialized MapViewModel")
        if editingLocation != nil {
            self.editingLocation = editingLocation?.getCLLocation()
            self.isIncludingLocation = true
        }
        self.isIncludingLocation = isIncludingLocation
        self.locationManager = LocationManager(delegate: self)
        self.locationManager.checkIfLocationServicesIsEnabled()
    }
    
    // MARK: - Alert methods
    func alertUser(_ message: String) {
        alertMessage = message
        isShowingAlert = true
    }
    
    // MARK: - Location methods
    func disableLocation() {
        isIncludingLocation = false
        isLocationAvailable = false
    }

    func getCurrentLocation() -> Coordinate2D? {
        isIncludingLocation ? finalLocation.toCoordinate2D() : nil
    }
    
    func getLocationName() {
        locationGeocoder.getLocationName(rawLocation: finalLocation) { place in
            self.locationName = place
        }
    }
    
    func resetLocation() {
        editingLocation = nil
        userCustomLocation = nil
        withAnimation {
            mapRegionPosition = .region(MKCoordinateRegion(center: finalLocation, span: MapDetails.defaultSpan))
        }
    }
    
}

// MARK: - LocationHandlerDelegate conformance
extension MapViewModel: LocationHandlerDelegate {
    
    func didUpdateLocation(_ location: CLLocationCoordinate2D?) {
        print("Updating locaiton to: \(location ?? MapDetails.defaultRegion)")
        gpsLocation = location ?? MapDetails.defaultRegion
        mapRegionPosition = .region(MKCoordinateRegion(center: finalLocation, span: MapDetails.defaultSpan))
        isLocationAvailable = true
    }
    
    func didFailWithError(error: Error) {
        switch error {
        case LocationError.locationServicesDisabled:
            disableLocation()
            showAlerts ? alertUser("Location services seem to be turned off.") : nil
        case LocationError.locationRestricted:
            disableLocation()
            showAlerts ? alertUser("Tour location is restricted likely due to parental controls.") : nil
        case LocationError.locationDenied:
            disableLocation()
            showAlerts ? alertUser("You have denied location permission, you can re-enable it in settings") : nil
        case LocationError.unknownAuthorizationStatus:
            disableLocation()
            showAlerts ? alertUser("Unknown locationManager authrorization status, contact developer.") : nil
        case LocationError.locationNotAvailable:
            disableLocation()
            showAlerts ? alertUser("Location not available.") : nil
        default:
            break
        }
    }
    
}

