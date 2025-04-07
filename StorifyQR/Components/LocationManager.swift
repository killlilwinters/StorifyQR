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
    func didUpdateLocation(_ location: CLLocationCoordinate2D?)
    func didFailWithError(error: Error)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    weak var delegate: LocationHandlerDelegate?
    
    private var locationManager: CLLocationManager?
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        delegate?.didUpdateLocation(location.coordinate)
    }
    
    private func handleAuthorizedLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    init(delegate: LocationHandlerDelegate) {
        super.init()
        self.delegate = delegate
        self.locationManager = CLLocationManager()
        self.locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager!.delegate = self
    }
    
    deinit {
        print("LocationManager destroyed.")
    }
    
}
