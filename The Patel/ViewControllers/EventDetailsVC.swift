//
//  EventDetailsVC.swift
//  The Patel
//
//  Created by Akash on 05/03/24.
//

import UIKit
import MapKit

class EventDetailsVC: UIViewController {
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var organizerName: UILabel!
    @IBOutlet weak var organizerLocation: UILabel!
    @IBOutlet weak var organizerImage: UIImageView!
    @IBOutlet weak var eventLocation: MKMapView!
    @IBOutlet weak var chiefGuestCollection: UICollectionView!
    @IBOutlet weak var eventImages: UICollectionView!
    @IBOutlet weak var btnRegister: UIButton!
    
    var event: Event?
    var organizer: UserProfile?
    var annotation: CustomAnnotation?
    var chiefGuest: [UserProfile] = []
    var images: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setOrganizer(){
        LocationManager.get.locationFromCordinate(latitude: CLLocationDegrees(organizer?.currentLocation?[0] ?? 0.0), longitude: CLLocationDegrees(organizer?.currentLocation?[1] ?? 0.0), complationHandler: { location,error in
            if error == nil{
                self.organizerLocation.text = location?.getData()
            } else {
                self.organizerLocation.text = ""
                self.view.makeToast(error)
            }
        })
        organizerImage.kf.setImage(with: URL(string: organizer?.profilepicture ?? ""))
        organizerName.text = organizer?.getFullName()
    }
    
    private func setup(){
        FirestoreManager.shared.getDocument(collection: .User, name: event?.organizer ?? "", complationHandler: { status,error,organizer in
            if status == true{
                self.organizer = UserProfile(json: organizer ?? [:])
                self.setOrganizer()
            } else {
                self.view.makeToast(error)
            }
        })
        let latitude = CLLocationDegrees(event?.latitude ?? 0.0)
        let longitude = CLLocationDegrees(event?.longitude ?? 0.0)
        self.annotation = CustomAnnotation(title: LocationKey.venuePlace, subtitle: "", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        self.eventLocation.addAnnotation(self.annotation!)
        self.eventLocation.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        self.eventName.text = event?.name
        self.eventDescription.text = event?.description
        self.eventDate.text = event?.dateandtime
        chiefGuestCollection.register(UINib(nibName: NibsKey.chiefGuest, bundle: nil), forCellWithReuseIdentifier: NibsKey.chiefGuestIdentifier)
        eventImages.register(UINib(nibName: NibsKey.eventImagesCollection, bundle: nil), forCellWithReuseIdentifier: NibsKey.eventImagesCollectionIdentifier)
        if event?.images != nil{
            images = event?.images ?? []
            eventImages.reloadData()
        }
        guard let user = UserDefaults.standard.object(forKey: UserSession.user) as? [String:Any] else { return }
        guard let email = user[UserSession.email] as? String, let userid = user[UserSession.userID] as? String else { return }
        guard let guestList = event?.guest, let chiefGuest = event?.chiefGuest else { return }
        if guestList.contains(email) || userid == event?.organizer || chiefGuest.contains(email){
            btnRegister.isHidden = true
        }
        getChiefGuestData(guestList: chiefGuest)
    }
    
    private func getChiefGuestData(guestList: [String]){
        for index in 0...guestList.count-1{
            FirestoreManager.shared.getDocumentByKeyValue(collection: .User, key: ModelKey.email, value: guestList[index], complationHandler: { status,error,data in
                if status == true{
                    if let guest = data{
                        for user in guest{
                            self.chiefGuest.append(UserProfile(json: user))
                        }
                    }
                    self.chiefGuestCollection.reloadData()
                }
            })
        }
    }
    
    @IBAction func backbtnClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func navigateClicked(_ sender: UIButton){
        let coordinate = CLLocationCoordinate2D(latitude: event?.latitude ?? 0.0, longitude: event?.longitude ?? 0.0)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = LocationKey.venuePlace
        // Set the map region span
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)])
    }
    
    @IBAction func registerInEvent(_ sender: UIButton){
        guard let eventID = event?.id, var guestList = event?.guest else { return }
        guard let user = UserDefaults.standard.object(forKey: UserSession.user) as? [String:Any] else { return }
        guestList.append(user[UserSession.email] as? String ?? "")
        let json = [ModelKey.guest:guestList]
        FirestoreManager.shared.setDocument(collection: .Event, key: eventID, data: json, merge: true, complationHandler: { status,error in
            if status == true{
                self.btnRegister.isHidden = true
            } else {
                self.view.makeToast(error)
            }
        })
    }
}

extension EventDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == chiefGuestCollection{
            return chiefGuest.count
        } else {
            return images.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == chiefGuestCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NibsKey.chiefGuestIdentifier, for: indexPath) as! ChiefGuest
            cell.guestName.text = chiefGuest[indexPath.row].getFullName()
            cell.guestImage.kf.setImage(with: URL(string: chiefGuest[indexPath.row].profilepicture ?? ""))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NibsKey.eventImagesCollectionIdentifier, for: indexPath) as! EventImagesCollection
            cell.eventImage.kf.setImage(with: URL(string: images[indexPath.row]))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == chiefGuestCollection{
            return CGSize(width: (collectionView.bounds.width / 3 - 15) , height: collectionView.bounds.height)
        } else {
            return CGSize(width: (collectionView.bounds.width) , height: collectionView.bounds.height)
        }
    }
}

