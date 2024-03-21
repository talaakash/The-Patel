//
//  EventVC.swift
//  The Patel
//
//  Created by Akash on 04/03/24.
//

import UIKit

class EventVC: UIViewController {

    @IBOutlet weak var eventsCollection: UICollectionView!
    
    var events: [Event] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        preLoding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setup()
    }
    
    private func preLoding(){
        eventsCollection.register(UINib(nibName: NibsKey.event, bundle: nil), forCellWithReuseIdentifier: NibsKey.eventIdentifier)
        let eventList = DataHandler.shared.getData(model: Event.self, key: UserSession.events)
        events = eventList ?? []
        
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
    
    private func setup(){
        FirestoreManager.shared.getDocuments(collection: .Event, complationHandler: { status,error,data in
            if status == true{
                self.events = []
                for event in data ?? []{
                    self.events.append(Event(json: event))
                }
                DataHandler.shared.setData(model: Event.self, key: UserSession.events, data: self.events)
                self.eventsCollection.reloadData()
            } else {
                self.view.makeToast(error)
            }
        })
    }

    @IBAction func btnBackClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddClicked(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.sceduleEventScreen) as? SceduleEventVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}

extension EventVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NibsKey.eventIdentifier, for: indexPath) as! Events
        cell.eventName.text = events[indexPath.row].name
        cell.eventDate.text = "\(events[indexPath.row].dateandtime.getDate()) \(events[indexPath.row].dateandtime.getTime())"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.eventDetailsScreen) as? EventDetailsVC
        vc?.event = events[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 90)
    }
}
