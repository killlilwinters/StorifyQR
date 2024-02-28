//
//  LocationManager.swift
//  StorifyQR
//
//  Created by Maks Winters on 27.02.2024.
//

import CoreLocation

enum LocationError: Error {
    case locationServicesDisabled
    case locationRestricted
    case locationDenied
    case unknownAuthorizationStatus
    case locationNotAvailable
}

protocol LocationHandlerDelegate: AnyObject {
    func didUpdateLocation()
    func didFailWithError(error: Error)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    weak var delegate: LocationHandlerDelegate?
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        DispatchQueue.global().async {
            guard CLLocationManager.locationServicesEnabled() else {
                self.delegate?.didFailWithError(error: LocationError.locationServicesDisabled)
                return
            }
        }
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            delegate?.didFailWithError(error: LocationError.locationRestricted)
        case .denied:
            delegate?.didFailWithError(error: LocationError.locationDenied)
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            handleAuthorizedLocation()
        @unknown default:
            delegate?.didFailWithError(error: LocationError.unknownAuthorizationStatus)
        }
    }
    
    private func handleAuthorizedLocation() {
        if locationManager?.location?.coordinate != nil {
            // Handle location update
            delegate?.didUpdateLocation()
        } else {
            delegate?.didFailWithError(error: LocationError.locationNotAvailable)
        }
    }
    
    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func getCurrentLocation() -> CLLocationCoordinate2D? {
        if let location = locationManager?.location?.coordinate {
            return location
        } else {
            return nil
        }
    }
    
    init(delegate: LocationHandlerDelegate) {
        super.init()
        self.delegate = delegate
        self.locationManager = CLLocationManager()
        self.locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager!.delegate = self
    }
    
}
