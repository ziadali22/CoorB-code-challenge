//
//  LocationManager.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 21/06/2025.
//
import SwiftUI
import CoreLocation
import CoreLocationUI

// MARK: - Location Service
import CoreLocation

protocol LocationManagerProtocol: ObservableObject {
    var authorizationStatus: CLAuthorizationStatus { get }
    func requestLocationPermission()
    func getCurrentCountryCode() async -> String?
}

class LocationManager: NSObject, LocationManagerProtocol, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationManager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocation?, Never>?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentCountryCode() async -> String? {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            return nil
        }
        
        return await withCheckedContinuation { continuation in
            self.locationContinuation = continuation
            locationManager.requestLocation()
        }?.countryCode
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            locationContinuation?.resume(returning: nil)
            locationContinuation = nil
            return
        }
        
        locationContinuation?.resume(returning: location)
        locationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(returning: nil)
        locationContinuation = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}

extension CLLocation {
    var countryCode: String? {
        let geocoder = CLGeocoder()
        var countryCode: String?
        let semaphore = DispatchSemaphore(value: 0)
        
        geocoder.reverseGeocodeLocation(self) { placemarks, _ in
            countryCode = placemarks?.first?.isoCountryCode
            semaphore.signal()
        }
        
        semaphore.wait()
        return countryCode
    }
}
