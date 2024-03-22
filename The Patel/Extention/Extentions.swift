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
        dateFormatter.dateFormat = DatesFormates.timeFormat
        let time = dateFormatter.string(from: self)
        return time
    }
    
    func getDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DatesFormates.dateFormat
        let date = dateFormatter.string(from: self)
        return date
    }
    
    func timeAgo() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let month = 30 * day
        let year = 12 * month
        
        if secondsAgo == 0{
            return "Just Now"
        } else if secondsAgo < minute {
            return "\(secondsAgo) seconds ago"
        } else if secondsAgo < hour {
            let minutes = secondsAgo / minute
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        } else if secondsAgo < day {
            let hours = secondsAgo / hour
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else if secondsAgo < month {
            let days = secondsAgo / day
            return "\(days) day\(days == 1 ? "" : "s") ago"
        } else if secondsAgo < year {
            let months = secondsAgo / month
            return "\(months) month\(months == 1 ? "" : "s") ago"
        } else {
            let years = secondsAgo / year
            return "\(years) year\(years == 1 ? "" : "s") ago"
        }
    }
}

extension UIImageView{
    func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
        addGestureRecognizer(doubleTapGesture)
        pinchGesture.require(toFail: doubleTapGesture)
    }
    
    @objc private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
    
    @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let scale: CGFloat = 2.0
            let newTransform = transform.scaledBy(x: scale, y: scale)
            UIView.animate(withDuration: 0.3) {
                self.transform = newTransform
            }
        }
    }
}
