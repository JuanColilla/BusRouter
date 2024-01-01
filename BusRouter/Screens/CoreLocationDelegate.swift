//
//  CoreLocationDelegate.swift
//  BusRouter
//
//  Created by Juan Colilla on 1/1/24.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    // MARK: Delegate Publisheres
    @Published
    var location: CLLocation?
    
    @Published
    var authorizationStatus: CLAuthorizationStatus

    override init() {
        // LocationManagerDelegate Properties Initialization
        self.authorizationStatus = .notDetermined
        
        // Parent Constructor Initialization
        super.init()
        
        // Delegate Functions Execution
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.authorizationStatus = locationManager.authorizationStatus
        self.locationManager.startUpdatingLocation()
    }

    // MARK: Delegate Functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
    
    // Handle the failure case
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}

// MARK: CoreLocation Custom Errors

enum CLError: LocalizedError, Equatable {
    case permissionDenied
    case other
}
