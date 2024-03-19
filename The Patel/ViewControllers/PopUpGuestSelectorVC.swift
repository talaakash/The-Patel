//
//  PopUpGuestSelectorVC.swift
//  The Patel
//
//  Created by Akash on 04/03/24.
//

import UIKit
import Kingfisher

class PopUpGuestSelectorVC: UIViewController {

    @IBOutlet weak var guestProfiletbl: UITableView!
    var users: [UserProfile] = []
    var currentUsers: [UserProfile] = []
    var closure: ((UserProfile) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup(){
        let nib = UINib(nibName: NibsKey.guestProfile, bundle: nil)
        guestProfiletbl.register(nib, forCellReuseIdentifier: NibsKey.guestProfileIdentifier)
        currentUsers = users
    }
    
    private func changeCurrentData(search: String){
        if search != ""{
            currentUsers = users.filter({ "\($0.name ?? "") \($0.surname ?? "")".contains(search)  })
        } else {
            currentUsers = users
        }
        guestProfiletbl.reloadData()
    }
}

extension PopUpGuestSelectorVC: UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        changeCurrentData(search: searchText)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NibsKey.guestProfileIdentifier, for: indexPath) as! GuestProfile
        let cellUser = currentUsers[indexPath.row]
        cell.guestImage.kf.setImage(with: URL(string: cellUser.profilepicture ?? ""))
        cell.guestName.text = "\(cellUser.name ?? "") \(cellUser.surname ?? "")"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        closure?(currentUsers[indexPath.row])
        self.dismiss(animated: true)
    }
    
}
