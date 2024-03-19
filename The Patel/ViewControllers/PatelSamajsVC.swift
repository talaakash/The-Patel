//
//  PatelSamajsVC.swift
//  The Patel
//
//  Created by Akash on 11/03/24.
//

import UIKit
import Toast_Swift

class PatelSamajsVC: UIViewController {

    @IBOutlet weak var samajList: UITableView!
    var samajs: [Samaj] = []
    var locations: [Location] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        preLoading()
    }
    override func viewWillAppear(_ animated: Bool) {
        setup()
    }
    
    private func preLoading(){
//        let samajList = DataHandler.shared.getData(model: Samaj.self, key: UserSession.samajs)
//        let samajLocation = DataHandler.shared.getData(model: Location.self, key: UserSession.locationForSamajs)
//        samajs = samajList ?? []
//        locations = samajLocation ?? []
//        if samajList == nil || samajLocation == nil{
//            ProgressBar.shared.show()
//            samajs = []
//            locations = []
//        }
    }
    
    private func setup(){
        ProgressBar.shared.show()
        FirestoreManager.shared.getDocuments(collection: .Samaj, complationHandler: { status, error, json in
            if status == true{
                if let data = json{
                    self.samajs = []
                    self.locations = []
                    for samaj in data{
                        self.samajs.append(Samaj(json: samaj))
                    }
                    for samaj in self.samajs{
                        LocationManager.get.locationFromCordinate(latitude: samaj.latitude, longitude: samaj.longitude, complationHandler: { location, error in
                            if error == nil{
                                if let area = location{
                                    self.locations.append(area)
                                } else {
                                    self.view.makeToast(ErrorKey.errorMessage)
                                }
                            } else {
                                self.view.makeToast(error)
                            }
                        })
                    }
                } else {
                    self.view.makeToast(ErrorKey.errorMessage)
                }
            } else {
                self.view.makeToast(error)
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            ProgressBar.shared.hide()
            DataHandler.shared.setData(model: Samaj.self, key: UserSession.samajs, data: self.samajs)
            DataHandler.shared.setData(model: Location.self, key: UserSession.locationForSamajs, data: self.locations)
            self.samajList.reloadData()
        })
        samajList.register(UINib(nibName: NibsKey.patelSamajList, bundle: nil), forCellReuseIdentifier: NibsKey.patelSamajListIdentifier)
    }

    @IBAction func backButtonClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.addSamajScreen) as? AddSamajVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension PatelSamajsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return samajs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NibsKey.patelSamajListIdentifier, for: indexPath) as! SamajsList
        cell.location.text = locations[indexPath.row].getLocation()
        cell.title.text = samajs[indexPath.row].name
        cell.samajImage.kf.setImage(with: URL(string: samajs[indexPath.row].images.first ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.samajDetailsScreen) as? SamajDetailVC
        vc?.samaj = samajs[indexPath.row]
        vc?.location = locations[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
