//
//  LocationService.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//

import UIKit
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var location: ((CLLocation) -> Void)?
    var error: ((Error) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location?(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error?(error)
    }
}
