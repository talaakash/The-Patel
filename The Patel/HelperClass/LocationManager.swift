//
//  Location.swift
//  The Patel
//
//  Created by Akash on 29/02/24.
//

import Foundation
import CoreLocation

class LocationManager{
    static let get = LocationManager()
    private init(){}
    
    func locationFromCordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees, complationHandler: @escaping (Location?,String?) -> Void){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude), completionHandler: { placemark,error in
            if let error = error{
                complationHandler(nil,error.localizedDescription)
            }
            else if let placemark = placemark?.first{
                complationHandler(Location(placemark: placemark),nil)
            }
            else{
                complationHandler(nil,ErrorKey.errorMessage)
            }
        })
    }
}
