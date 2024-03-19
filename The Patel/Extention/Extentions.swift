//
//  Extentions.swift
//  The Patel
//
//  Created by Akash on 01/03/24.
//

import Foundation
import MapKit

extension MKMapView{
    
    func setCordinate(lattitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let location = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.setRegion(region, animated: true)
        let pin = CustomAnnotation(title: "", subtitle: "", coordinate: location)
        self.addAnnotation(pin)
    }
}

extension Date{
    
    func getTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ModelKey.timeFormat
        let time = dateFormatter.string(from: self)
        return time
    }
    
    func getDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ModelKey.userDateFormat
        let date = dateFormatter.string(from: self)
        return date
    }
}
