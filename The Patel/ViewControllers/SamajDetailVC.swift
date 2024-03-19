//
//  SamajDetailVC.swift
//  The Patel
//
//  Created by Akash on 11/03/24.
//

import UIKit
import MapKit
import Kingfisher

class SamajDetailVC: UIViewController {

    @IBOutlet weak var images: UICollectionView!
    @IBOutlet weak var facility: UICollectionView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var samajDescription: UILabel!
    @IBOutlet weak var samajLocation: MKMapView!
    @IBOutlet weak var pageControler: UIPageControl!
    var samaj: Samaj?
    var location: Location?
    var image: [String]?
    var facilities: [String]?
    var currentPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    private func setup(){
        name.text = samaj?.name
        samajDescription.text = samaj?.description
        image = samaj?.images
        facilities = samaj?.facilities
        let cordinate = CLLocationCoordinate2D(latitude:   CLLocationDegrees(samaj?.latitude ?? 0.0) , longitude: CLLocationDegrees(samaj?.longitude ?? 0.0))
        let anotation = CustomAnnotation(title: LocationKey.patelSamaj, subtitle: "", coordinate: cordinate)
        samajLocation.addAnnotation(anotation)
        let region = MKCoordinateRegion(center: cordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        samajLocation.setRegion(region, animated: true)
        pageControler.numberOfPages = image?.count ?? 0
        images.register(UINib(nibName: NibsKey.eventImagesCollection, bundle: nil), forCellWithReuseIdentifier: NibsKey.eventImagesCollectionIdentifier)
        facility.register(UINib(nibName: NibsKey.searchFilter, bundle: nil), forCellWithReuseIdentifier: NibsKey.searchFilterIdentifier)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [self]_ in
            changeImage()
        })
    }
    
    private func changeImage(){
        currentPage += 1
        if currentPage >= image?.count ?? 0{
            currentPage = 0
        }
        pageControler.currentPage = currentPage
        let indexPath = IndexPath(item: currentPage, section: 0)
        images.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    @IBAction func navigationClicked(_ sender: UIButton){
        let coordinate = CLLocationCoordinate2D(latitude: samaj?.latitude ?? 0.0, longitude: samaj?.longitude ?? 0.0)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = LocationKey.patelSamaj
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)])
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

}
extension SamajDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == images{
            return image?.count ?? 0
        } else {
            return facilities?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == images{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NibsKey.eventImagesCollectionIdentifier, for: indexPath) as! EventImagesCollection
            cell.eventImage.kf.setImage(with: URL(string: image?[indexPath.row] ?? ""))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NibsKey.searchFilterIdentifier, for: indexPath) as! FilterSearch
            cell.filterName.text = facilities?[indexPath.row] ?? ""
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
}
