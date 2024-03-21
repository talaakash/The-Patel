//
//  ReputedPeopleProfileVC.swift
//  The Patel
//
//  Created by Akash on 18/03/24.
//

import UIKit
import MapKit
import Kingfisher
import Toast_Swift

class ReputedPeopleProfileVC: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var reputeddescription: UILabel!
    @IBOutlet weak var buisness: UILabel!
    @IBOutlet weak var birthdate: UILabel!
    @IBOutlet weak var imagesCollection: UICollectionView!
    @IBOutlet weak var awardsCollection: UICollectionView!
    @IBOutlet weak var location: MKMapView!
    
    var profile: ReputedPeople?
    var images: [String] = []
    var awards: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        imagesCollection.register(UINib(nibName: NibsKey.eventImagesCollection, bundle: nil), forCellWithReuseIdentifier: NibsKey.eventImagesCollectionIdentifier)
        awardsCollection.register(UINib(nibName: NibsKey.eventImage, bundle: nil), forCellWithReuseIdentifier: NibsKey.eventImageIdentifier)
        name.text = profile?.name
        buisness.text = profile?.business
        reputeddescription.text = profile?.description
        birthdate.text = profile?.birthDate.getDate()
        let latitude = profile?.latitude ?? 0.0
        let longitude = profile?.longitude ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        location.addAnnotation(CustomAnnotation(title: "", subtitle: "", coordinate: coordinate))
        location.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
        images = profile?.images ?? []
        awards = profile?.awards ?? []
        
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
    
    @IBAction func navigationClicked(_ sender: UIButton){
        let coordinate = CLLocationCoordinate2D(latitude: profile?.latitude ?? 0.0, longitude: profile?.longitude ?? 0.0)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)])
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ReputedPeopleProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imagesCollection{
            return images.count
        } else {
            return awards.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imagesCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NibsKey.eventImagesCollectionIdentifier, for: indexPath) as! EventImagesCollection
            cell.eventImage.kf.setImage(with: URL(string: images[indexPath.row]))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NibsKey.eventImageIdentifier, for: indexPath) as! EventImages
            cell.imageName.text = awards[indexPath.row]
            cell.cancelbtn.isHidden = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imagesCollection{
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
}
