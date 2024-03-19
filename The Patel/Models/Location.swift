//
//  Location.swift
//  The Patel
//
//  Created by Akash on 01/03/24.
//

import Foundation
import CoreLocation

class Location{
    let name: String
    let street: String
    let locality: String
    let state: String
    let country: String
    let pincode: String
    init(placemark: CLPlacemark) {
        self.name = placemark.name ?? ""
        self.street = placemark.thoroughfare ?? ""
        self.locality = placemark.locality ?? ""
        self.state = placemark.administrativeArea ?? ""
        self.country = placemark.country ?? ""
        self.pincode = placemark.postalCode ?? ""
    }
    
    func getLocation() -> String{
        return "\(locality), \(state), \(country)"
    }
    
    func getData() -> String{
        return "\(name), \(street), \(locality), \(state), \(country), \(pincode)"
    }
}
