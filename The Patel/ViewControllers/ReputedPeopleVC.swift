//
//  ReputedPeopleVC.swift
//  The Patel
//
//  Created by Akash on 14/03/24.
//

import UIKit
import Toast_Swift
import Kingfisher

class ReputedPeopleVC: UIViewController {

    @IBOutlet weak var reputedPeopleTbl: UITableView!
    var reputedPeople: [ReputedPeople] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        preLoading()
    }
    override func viewWillAppear(_ animated: Bool) {
        setup()
    }
    
    private func preLoading(){
        let reputedPeopleList = DataHandler.shared.getData(model: ReputedPeople.self, key: UserSession.reputedPeople)
        reputedPeople = reputedPeopleList ?? []
        if reputedPeopleList == nil{
            ProgressBar.shared.show()
        }
    }
    
    private func setup(){
        reputedPeopleTbl.register(UINib(nibName: NibsKey.commonSearchResult, bundle: nil), forCellReuseIdentifier: NibsKey.commonSearchResultIdentifier)
        FirestoreManager.shared.getDocuments(collection: .reputedPeople, complationHandler: { status, error, snapShot in
            if status == true{
                if let data = snapShot{
                    self.reputedPeople = []
                    for people in data{
                        self.reputedPeople.append(ReputedPeople(json: people))
                    }
                } else { self.view.makeToast(ErrorKey.errorMessage) }
            } else { self.view.makeToast(error) }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            ProgressBar.shared.hide()
            DataHandler.shared.setData(model: ReputedPeople.self, key: UserSession.reputedPeople, data: self.reputedPeople)
            self.reputedPeopleTbl.reloadData()
        })
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.addReputedPeopleScreen) as? AddReputedPeopleVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}
extension ReputedPeopleVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reputedPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NibsKey.commonSearchResultIdentifier, for: indexPath) as! CommonSearchResult
        let people = reputedPeople[indexPath.row]
        cell.searchImage.kf.setImage(with: URL(string: people.images.first ?? ""))
        cell.searchTitle.text = people.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.reputedPeopleProfileScreen) as? ReputedPeopleProfileVC
        vc?.profile = reputedPeople[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
