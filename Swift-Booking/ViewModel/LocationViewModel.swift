//
//  LocationViewModel.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//


import Foundation
import CoreLocation

class LocationViewModel {
    private let locationService = LocationService()
    var location: ((CLLocation, String) -> Void)?
    var error: ((Error) -> Void)?
    let geocoder = CLGeocoder()
    var tempLocation : CLLocation?
    
    func getLocation() {
        locationService.location = { [weak self] location in
            guard let self = self else {return}
            self.getAddress(loc: location) { [weak self] address in
                self?.location?(location, address)
                
            }
           
        }
        locationService.error = { error in
            self.error?(error)
        }
        locationService.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationService.stopUpdatingLocation()
    }
    
    func getAddress(loc: CLLocation,completion: ((String) -> Void)?){
        geocoder.reverseGeocodeLocation(loc) { (placemarks, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first {
                // You can access the address components using the placemark object
                let streetNumber = placemark.subThoroughfare ?? ""
                let streetName = placemark.thoroughfare ?? ""
                let city = placemark.locality ?? ""
                let state = placemark.administrativeArea ?? ""
                let zipCode = placemark.postalCode ?? ""
                let country = placemark.country ?? ""

                let address = "\(streetNumber) \(streetName), \(city), \(state) \(zipCode), \(country)"
                print(address)
                completion?(address)
            }
        }
    }
}
