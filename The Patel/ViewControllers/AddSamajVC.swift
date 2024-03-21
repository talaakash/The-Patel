//
//  AddSamajVC.swift
//  The Patel
//
//  Created by Akash on 11/03/24.
//

import UIKit
import MapKit

class AddSamajVC: UIViewController {
    
    @IBOutlet weak var txtFacility: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var facilityCollection: UICollectionView!
    @IBOutlet weak var imagesCollection: UICollectionView!
    @IBOutlet weak var location: MKMapView!
    var facilities: [String] = []
    var images: [String] = []
    var imagesData: [UIImage] = []
    var annonation: CustomAnnotation?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        facilityCollection.register(UINib(nibName: NibsKey.eventImage, bundle: nil), forCellWithReuseIdentifier: NibsKey.eventImageIdentifier)
        imagesCollection.register(UINib(nibName: NibsKey.eventImage, bundle: nil), forCellWithReuseIdentifier: NibsKey.eventImageIdentifier)
        let onLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:)))
        location.addGestureRecognizer(onLongPressGesture)
        
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
            let touchLocation = gestureRecognizer.location(in: location)
            let cordinate = location.convert(touchLocation, toCoordinateFrom: location)
            location.removeAnnotations(location.annotations)
            annonation = CustomAnnotation(title: LocationKey.patelSamaj, subtitle: "", coordinate: cordinate)
            location.addAnnotation(annonation ?? CustomAnnotation(title: LocationKey.nativePlace, subtitle: "", coordinate: cordinate))
        }
    }
    
    private func uploadImage(image: UIImage, name: String){
        images.append(name)
        imagesData.append(image)
        imagesCollection.reloadData()
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addFacilityClicked(_ sender: UIButton){
        guard let facility = txtFacility.text else { self.view.makeToast(ErrorKey.invalidDetails); return }
        if facility == ""{ self.view.makeToast(ErrorKey.invalidDetails); return }
        txtFacility.text = ""
        facilities.append(facility)
        facilityCollection.reloadData()
    }
    
    @IBAction func addImageClicked(_ sender: UIButton){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func uploadData(_ sender: UIButton){
        guard let name = txtName.text, let description = txtDescription.text else { self.view.makeToast(ErrorKey.invalidDetails); return }
        guard let location = annonation?.coordinate else { self.view.makeToast(LocationKey.enterLocation); return }
        if name == "", description == "", imagesData == [], facilities == []{ self.view.makeToast(ErrorKey.invalidDetails); return }
        var imageUrlString: [String] = []
        ProgressBar.shared.show()
        for image in imagesData{
            FirebaseStorageManager.shared.storeData(type: .SamajPicture, image: image, complationHandler: { status, error, url in
                if status == true{
                    imageUrlString.append(String(describing: url ?? URL(filePath: "")))
                } else { self.view.makeToast(error) }
                if imageUrlString.count == self.imagesData.count{
                    let documentID = FirestoreManager.shared.getUniqueID(collection: .Samaj)
                    FirestoreManager.shared.setDocument(collection: .Samaj, key: documentID, data: [ModelKey.samajName: name, ModelKey.samajDescription: description, ModelKey.samajFacilities: self.facilities, ModelKey.samajImages: imageUrlString, ModelKey.samajLatitude: location.latitude, ModelKey.samajLongitude: location.longitude], complationHandler: { status, error in
                        if status == true{
                            self.navigationController?.popViewController(animated: true)
                        } else { self.view.makeToast(error) }
                    })
                }
            })
        }
    }
    
}
extension AddSamajVC: UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func cancelClicked(_ sender: UIButton){
        let indexPath = IndexPath(item: sender.tag, section: 0)
        if indexPath.row < 0 { return }
        if indexPath.row < facilities.count{
            facilities.remove(at: indexPath.row)
            facilityCollection.reloadData()
        } else {
            let index = indexPath.row - (facilities.count)
            images.remove(at: index)
            imagesData.remove(at: index)
            imagesCollection.reloadData()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage, let name = info[.imageURL] as? URL {
            uploadImage(image: image,name: name.lastPathComponent)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == facilityCollection{
            return facilities.count
        } else {
            return images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == facilityCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NibsKey.eventImage, for: indexPath) as! EventImages
            cell.imageName.text = facilities[indexPath.row]
            cell.cancelbtn.addTarget(self, action: #selector(cancelClicked(_:)), for: .touchUpInside)
            cell.cancelbtn.tag = indexPath.row
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NibsKey.eventImage, for: indexPath) as! EventImages
            cell.imageName.text = images[indexPath.row]
            cell.cancelbtn.addTarget(self, action: #selector(cancelClicked(_:)), for: .touchUpInside)
            cell.cancelbtn.tag = indexPath.row + facilities.count
            return cell
        }
    }
}
