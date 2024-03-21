//
//  UserInfoGettingVC.swift
//  The Patel
//
//  Created by Akash on 26/02/24.
//

import UIKit
import CoreLocation
import MapKit

class UserInfoGettingVC: UIViewController{

    @IBOutlet weak var birthdate: UIDatePicker!
    @IBOutlet weak var educationTitle: UITextField!
    @IBOutlet weak var educationDescription: UITextField!
    @IBOutlet weak var occupationTitle: UITextField!
    @IBOutlet weak var occupationDescription: UITextField!
    @IBOutlet weak var currentMap: MKMapView!
    @IBOutlet weak var nativeMap: MKMapView!
    
    var annonation: CustomAnnotation?
    var locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        checkLocationAuthorizationStatus()
        
        let onLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:)))
        nativeMap.addGestureRecognizer(onLongPressGesture)
    }
    
    @objc func handleGesture(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state != UIGestureRecognizer.State.ended{
            let touchLocation = gestureRecognizer.location(in: nativeMap)
            let cordinate = nativeMap.convert(touchLocation, toCoordinateFrom: nativeMap)
            nativeMap.removeAnnotations(nativeMap.annotations)
            annonation = CustomAnnotation(title: LocationKey.nativePlace, subtitle: "", coordinate: cordinate)
            nativeMap.addAnnotation(annonation ?? CustomAnnotation(title: LocationKey.nativePlace, subtitle: "", coordinate: cordinate))
        }
    }
    
    private func checkLocationAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        case .denied:
            showAlertToEnableLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showAlertToEnableLocation()
        @unknown default:
            break
        }
    }
    
    func showAlertToEnableLocation() {
        let alert = UIAlertController(title: LocationKey.locationAlertTitle, message: LocationKey.locationAlertMessage, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: LocationKey.settingAlertTitle, style: .default) { (_) in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        alert.addAction(settingsAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: UIButton){
        let currentcordinate = locationManager.location?.coordinate ?? CLLocationCoordinate2D()
        let nativecordinate = annonation?.coordinate
        guard let educationTitle = educationTitle.text,let educationDescription = educationDescription.text,let occupationTitle = occupationTitle.text,let occupationDecription = occupationDescription.text else{
            self.view.makeToast(ErrorKey.invalidDetails)
            return
        }
        guard let user = UserDefaults.standard.object(forKey: UserSession.user) as? [String:Any] else { return }
        guard let userid = user[UserSession.userID] as? String else { return }
        FirestoreManager.shared.setDocument(collection: .User, key: userid, data: [ModelKey.birthDate:birthdate.date, ModelKey.currentLocation:[currentcordinate.latitude,currentcordinate.longitude],ModelKey.nativeLocation:[nativecordinate?.latitude,nativecordinate?.longitude],ModelKey.education:[ModelKey.educationTitle:educationTitle,ModelKey.educationDescription:educationDescription],ModelKey.occupation:[ModelKey.occupationTitle:occupationTitle,ModelKey.occupationDescription:occupationDecription]],merge: true, complationHandler: { status,error in
            if status == false{
                self.view.makeToast(error)
            }
            else{
                if let user = UserDefaults.standard.value(forKey: UserSession.user) as? [String:Any]{
                    FirestoreManager.shared.getDocument(collection: .User, name: user[UserSession.userID] as? String ?? "", complationHandler: { status,error,data in
                        if status == false{
                            self.view.makeToast(error)
                        }
                        else{
                            let userDetails = UserProfile(json: data ?? [:])
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.homeScreen) as! HomeVC
                            vc.userData = userDetails
                            let navigationController:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.navigationController) as! UINavigationController
                            navigationController.viewControllers = [vc]
                            UIApplication.shared.keyWindow?.rootViewController = navigationController
                        }
                    })
                }
                else{
                    self.view.makeToast(ErrorKey.errorMessage)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.loginScreen) as? LoginVC
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        })
    }

}

extension UserInfoGettingVC: CLLocationManagerDelegate, UIGestureRecognizerDelegate{
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let cordinate = manager.location?.coordinate ?? CLLocationCoordinate2D()
        let spanDegree = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: cordinate, span: spanDegree)
        currentMap.setRegion(region, animated: true)
        annonation = CustomAnnotation(title: LocationKey.nativePlace, subtitle: "", coordinate: cordinate)
        nativeMap.addAnnotation(annonation!)
    }
    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
//        if newState == .ending {
//            // Handle the end of dragging
//            if let annotation = view.annotation as? CustomAnnotation {
//                print("Annotation dragged to: \(annotation.coordinate)")
//            }
//        }
//    }
}

