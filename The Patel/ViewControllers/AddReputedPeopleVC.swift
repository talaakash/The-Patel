//
//  AddReputedPeopleVC.swift
//  The Patel
//
//  Created by Akash on 18/03/24.
//

import UIKit
import MapKit

class AddReputedPeopleVC: UIViewController {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextField!
    @IBOutlet weak var buisnessTxt: UITextField!
    @IBOutlet weak var birthDate: UIDatePicker!
    @IBOutlet weak var location: MKMapView!
    @IBOutlet weak var awardsCollection: UICollectionView!
    @IBOutlet weak var imagesCollection: UICollectionView!
    
    var annonation: CustomAnnotation?
    var imageUrl: [String] = []
    var images: [String] = []
    var awards: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        awardsCollection.register(UINib(nibName: NibsKey.eventImage, bundle: nil), forCellWithReuseIdentifier: NibsKey.eventImageIdentifier)
        imagesCollection.register(UINib(nibName: NibsKey.eventImage, bundle: nil), forCellWithReuseIdentifier: NibsKey.eventImageIdentifier)
        let onLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:)))
        location.addGestureRecognizer(onLongPressGesture)
    }
    
    @objc func handleGesture(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state != UIGestureRecognizer.State.ended{
            let touchLocation = gestureRecognizer.location(in: location)
            let cordinate = location.convert(touchLocation, toCoordinateFrom: location)
            location.removeAnnotations(location.annotations)
            annonation = CustomAnnotation(title: "", subtitle: "", coordinate: cordinate)
            location.addAnnotation(annonation ?? CustomAnnotation(title: "", subtitle: "", coordinate: cordinate))
        }
    }
    
    private func selectedImage(image: UIImage, name: String){
        FirebaseStorageManager.shared.storeData(type: .ReputedPeople, image: image, complationHandler: { status, error, url in
            if status == true{
                self.imageUrl.append(String(describing: url!))
                self.images.append(name)
                self.imagesCollection.reloadData()
            } else { self.view.makeToast(error) }
        })
    }

    @IBAction func addImage(_ sender: UIButton){
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func addAward(_ sender: UIButton){
        let alertController = UIAlertController(title: "Enter Value", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Award Name"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            if let textField = alertController.textFields?.first, let value = textField.text {
                if value == ""{ return }
                else{
                    self.awards.append(value)
                    self.awardsCollection.reloadData()
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton){
        guard let name = nameTxt.text, let description = descriptionTxt.text, let buisness = buisnessTxt.text, name != "" ,description != "", buisness != "" else { self.view.makeToast(ErrorKey.invalidDetails); return }
        guard let coordinate = annonation?.coordinate else { self.view.makeToast(LocationKey.enterLocation); return}
        let key = FirestoreManager.shared.getUniqueID(collection: .reputedPeople)
        FirestoreManager.shared.setDocument(collection: .reputedPeople, key: key, data: [ModelKey.reputedPeopleName: name, ModelKey.reputedPeopleDescription: description, ModelKey.reputedPeopleBirthdate: birthDate.date, ModelKey.reputedPeopleBusiness: buisness, ModelKey.reputedPeopleAwards: awards, ModelKey.reputedPeopleImages: imageUrl, ModelKey.reputedPeopleLatitude: coordinate.latitude, ModelKey.reputedPeopleLongitude: coordinate.longitude], complationHandler: { status, error in
            if status == true{
                self.navigationController?.popViewController(animated: true)
            } else {
                self.view.makeToast(error)
            }
        })
    }
}

extension AddReputedPeopleVC: UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imagesCollection{
            return images.count
        } else {
            return awards.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imagesCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NibsKey.eventImageIdentifier, for: indexPath) as! EventImages
            cell.imageName.text = images[indexPath.row]
            cell.cancelbtn.addTarget(self, action: #selector(cancelClicked(_:)), for: .touchUpInside)
            cell.cancelbtn.tag = indexPath.row
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NibsKey.eventImageIdentifier, for: indexPath) as! EventImages
            cell.imageName.text = awards[indexPath.row]
            cell.cancelbtn.addTarget(self, action: #selector(cancelClicked(_:)), for: .touchUpInside)
            cell.cancelbtn.tag = indexPath.row + images.count
            return cell
        }
    }
    
    @objc func cancelClicked(_ sender: UIButton){
        let indexPath = IndexPath(item: sender.tag, section: 0)
        if indexPath.row < 0 { return }
        if indexPath.row < images.count{
            images.remove(at: indexPath.row)
            imagesCollection.reloadData()
        } else {
            let index = indexPath.row - images.count
            awards.remove(at: index)
            awardsCollection.reloadData()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage, let imageName = info[.imageURL] as? URL {
            selectedImage(image: pickedImage, name: imageName.lastPathComponent)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
