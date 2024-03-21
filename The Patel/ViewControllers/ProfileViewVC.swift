//
//  ProfileViewVC.swift
//  The Patel
//
//  Created by Akash on 28/02/24.
//

import UIKit
import SnackBar_swift
import Kingfisher
import MapKit

class ProfileViewVC: UIViewController {

    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nativePlace: UILabel!
    @IBOutlet weak var birth: UILabel!
    @IBOutlet weak var currentPlace: UILabel!
    @IBOutlet weak var eduTitle: UILabel!
    @IBOutlet weak var eduDescription: UILabel!
    @IBOutlet weak var nativeMap: MKMapView!
    @IBOutlet weak var currentMap: MKMapView!
    @IBOutlet weak var nativeAddress: UILabel!
    @IBOutlet weak var currentAddress: UILabel!
    @IBOutlet weak var occupationTitle: UILabel!
    @IBOutlet weak var occupationDescription: UILabel!
    
    var userData: UserProfile?
    var currentLocation: Location?
    var nativeLocation: Location?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        let nativecordinate = userData?.nativeLocation
        let currentcordinate = userData?.currentLocation
        if let nativelatitude = nativecordinate?[0],let nativelongitude = nativecordinate?[1],let currentlatitude = currentcordinate?[0],let currentLongitude = currentcordinate?[1]{
            currentMap.setCordinate(lattitude: currentlatitude, longitude: currentLongitude)
            nativeMap.setCordinate(lattitude: nativelatitude, longitude: nativelongitude)
            LocationManager.get.locationFromCordinate(latitude: currentlatitude, longitude: currentLongitude, complationHandler: { location,error in
                self.currentLocation = location
                self.currentAddress.text = self.currentLocation?.getData()
                self.currentPlace.text = "\(self.currentPlace.text ?? "") \(self.currentLocation?.locality ?? "")"
            })
            LocationManager.get.locationFromCordinate(latitude: nativelatitude, longitude: nativelongitude, complationHandler: { location,error in
                self.nativeLocation = location
                self.nativeAddress.text = self.nativeLocation?.getData()
                self.nativePlace.text = "\(self.nativePlace.text ?? "") \(self.nativeLocation?.locality ?? "")"
            })
        }
        profilepic.kf.setImage(with: URL(string: userData?.profilepicture ?? ""))
        name.text = "\(userData?.name ?? "") \(userData?.surname ?? "")"
        birth.text = "\(birth.text ?? "") \(userData?.birthdate?.getDate() ?? "")"
        eduTitle.text = userData?.education?[ModelKey.educationTitle]
        eduDescription.text = userData?.education?[ModelKey.educationDescription]
        occupationTitle.text = userData?.occupation?[ModelKey.occupationTitle]
        occupationDescription.text = userData?.occupation?[ModelKey.occupationDescription]
        
        // Back Gesture
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePanGesture(_:)))
        edgePanGesture.edges = .left
        view.addGestureRecognizer(edgePanGesture)
    }
    
    @objc func handleEdgePanGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .ended {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
