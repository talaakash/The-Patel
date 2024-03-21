//
//  ScheduleEventVC.swift
//  The Patel
//
//  Created by Akash on 04/03/24.
//

import UIKit
import Kingfisher
import MapKit

class SceduleEventVC: UIViewController {

    @IBOutlet weak var guestListTbl: UITableView!
    @IBOutlet weak var venueLocation: MKMapView!
    @IBOutlet weak var uploadedImages: UICollectionView!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var eventDateTime: UIDatePicker!
    
    var users: [UserProfile] = []
    var usersFilteredData: [String:Int] = [:]
    var selectedGuest : [UserProfile] = []
    var annonation: CustomAnnotation?
    var images: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setNames(){
        for index in 0...users.count-1{
            usersFilteredData["\(users[index].name ?? "") \(users[index].surname ?? "")"] = index
        }
    }
    
    private func setup(){
        images.removeAll()
        FirestoreManager.shared.getDocuments(collection: .User, complationHandler: { status,error,data in
            if status == true{
                let usersProfiles = data ?? []
                for user in usersProfiles{
                    self.users.append(UserProfile(json: user))
                }
                self.setNames()
            }
            else{
                print(ErrorKey.errorMessage)
            }
        })
        let nib = UINib(nibName: NibsKey.guestProfile, bundle: nil)
        guestListTbl.register(nib, forCellReuseIdentifier: NibsKey.guestProfileIdentifier)
        let onLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:)))
        venueLocation.addGestureRecognizer(onLongPressGesture)
        uploadedImages.register(UINib(nibName: NibsKey.eventImagesCollection, bundle: nil), forCellWithReuseIdentifier: NibsKey.eventImagesCollectionIdentifier)
        
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
    
    
    @objc func handleGesture(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state != UIGestureRecognizer.State.ended{
            let touchLocation = gestureRecognizer.location(in: venueLocation)
            let cordinate = venueLocation.convert(touchLocation, toCoordinateFrom: venueLocation)
            venueLocation.removeAnnotations(venueLocation.annotations)
            annonation = CustomAnnotation(title: LocationKey.venuePlace, subtitle: "", coordinate: cordinate)
            venueLocation.addAnnotation(annonation!)
        }
    }
    
    private func uploadImage(image: UIImage){
        FirebaseStorageManager.shared.storeData(type: .EventPicture, image: image, complationHandler: { status,error,url in
            if status == true{
                self.images.append(String(describing: url ?? URL(fileURLWithPath: "")))
                self.uploadedImages.reloadData()
            } else {
                self.view.makeToast(error)
            }
        })
    }
    
    @IBAction func addImages(_ sender: UIButton){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func addGuest(_ sender: UIButton){
        let popupViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.popUpGuestSelectorScreen) as! PopUpGuestSelectorVC
        popupViewController.users = users
        popupViewController.closure = { user in
            self.selectedGuest.append(user)
            self.guestListTbl.reloadData()
        }
        popupViewController.modalPresentationStyle = .pageSheet
        popupViewController.sheetPresentationController?.detents = [.large()]
        popupViewController.sheetPresentationController?.prefersGrabberVisible = true
        present(popupViewController, animated: true)
    }
    
    @IBAction func backbtnClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createEvent(_ sender: UIButton){
        guard let eventName = self.eventName.text, let eventDescription = self.eventDescription.text, let venue = annonation?.coordinate, eventName != "", eventDescription != "" else { self.view.makeToast(ErrorKey.invalidDetails); return }
        guard let user = UserDefaults.standard.object(forKey: UserSession.user) as? [String:Any] else { return }
        guard let userid = user[UserSession.userID] as? String else { return }
        let guestid = selectedGuest.map({ $0.email })
        let uniqueID = FirestoreManager.shared.getUniqueID(collection: .Event)
        FirestoreManager.shared.setDocument(collection: .Event, key: uniqueID, data: [ModelKey.id:uniqueID, ModelKey.createDate: Date(), ModelKey.eventName: eventName, ModelKey.eventDescription: eventDescription, ModelKey.organizer: userid, ModelKey.latitude: venue.latitude, ModelKey.longitude: venue.longitude, ModelKey.dateandtime: eventDateTime.date, ModelKey.chiefGuest: guestid, ModelKey.guest: [], ModelKey.Images: images], complationHandler: { status,error in
            if status == true{
                self.navigationController?.popViewController(animated: true)
            } else {
                self.view.makeToast(error)
            }
        })
        
    }
    
}

extension SceduleEventVC : UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedGuest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NibsKey.guestProfileIdentifier, for: indexPath) as! GuestProfile
        let user = selectedGuest[indexPath.row]
        cell.guestImage.kf.setImage(with: URL(string: user.profilepicture ?? ""))
        cell.guestName.text = "\(user.name ?? "") \(user.surname ?? "")"
        return cell
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            uploadImage(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NibsKey.eventImagesCollectionIdentifier, for: indexPath) as! EventImagesCollection
        cell.eventImage.kf.setImage(with: URL(string: images[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
}
