//
//  SearchVC.swift
//  The Patel
//
//  Created by Akash on 01/03/24.
//

import UIKit
import Toast_Swift

class SearchVC: UIViewController {
    
    @IBOutlet weak var filterCollection: UICollectionView!
    @IBOutlet weak var filteredDataTable: UITableView!
    let filter = SearchFilter.shared.getSearchFilter()
    let filterColor = SearchFilter.shared.getFilterColor()
    var selectedFilter = SelectedFilter.filterAll
    var filterIndex = 0
    var users: [UserProfile] = []
    var filteredProfiles: [UserProfile]?
    var reputedPeople: [ReputedPeople] = []
    var filteredPeople: [ReputedPeople]?
    var samajs: [Samaj] = []
    var filteredSamajs: [Samaj]?
    var locations: [Location] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
//        ProgressBar.shared.show()
        filterCollection.register(UINib(nibName: NibsKey.searchFilter, bundle: nil), forCellWithReuseIdentifier: NibsKey.searchFilterIdentifier)
        filteredDataTable.register(UINib(nibName: NibsKey.commonSearchResult, bundle: nil), forCellReuseIdentifier: NibsKey.commonSearchResultIdentifier)
        FirestoreManager.shared.getDocuments(collection: .User, complationHandler: { status,error,data in
            if status == true{
                if let json = data{
                    for user in json{
                        self.users.append(UserProfile(json: user))
                    }
                }
            } else {
                self.view.makeToast(error)
            }
        })
        FirestoreManager.shared.getDocuments(collection: .reputedPeople, complationHandler: { status, error, snapshot in
            if status == true{
                if let data = snapshot{
                    for json in data{
                        self.reputedPeople.append(ReputedPeople(json: json))
                    }
                }
            } else {
                self.view.makeToast(error)
            }
        })
        FirestoreManager.shared.getDocuments(collection: .Samaj, complationHandler: { status, error, snapShot in
            if status == true{
                if let data = snapShot{
                    for samaj in data{
                        self.samajs.append(Samaj(json: samaj))
                    }
                }
            } else {
                self.view.makeToast(error)
            }
        })
    }
    
    private func searchData(search: String){
        if search == ""{
            return
        }
        switch selectedFilter{
        case .filterAll:
            filteredProfiles = SearchFilter.shared.filterByName(key: search, profiles: users)
            self.filteredDataTable.reloadData()
        case .filterSurname:
            filteredProfiles = SearchFilter.shared.filterBySurname(key: search, profiles: users)
            self.filteredDataTable.reloadData()
        case .filterProfile:
            filteredProfiles = SearchFilter.shared.filterByName(key: search, profiles: users)
            self.filteredDataTable.reloadData()
        case .filterReputedPeople:
            filteredPeople = SearchFilter.shared.filterByReputedPeople(key: search, profile: reputedPeople)
            self.filteredDataTable.reloadData()
        case .filterSamaj:
            filteredSamajs = SearchFilter.shared.filterBySamaj(key: search, samajas: samajs)
            self.filteredDataTable.reloadData()
        case .filterOccupation:
            filteredProfiles = SearchFilter.shared.filterByOcuupation(key: search, profiles: users)
            self.filteredDataTable.reloadData()
        case .filterLocation:
            print(selectedFilter.rawValue)
        }
    }
    
    @IBAction func backClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
extension SearchVC: UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData(search: searchText)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NibsKey.searchFilterIdentifier, for: indexPath) as! FilterSearch
        cell.filterName.text = filter[indexPath.row].rawValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: IndexPath(row: filterIndex, section: 0)) as? FilterSearch
        cell?.filterView.backgroundColor = UIColor(named: "BackGround")
        cell?.filterView.borderColor = UIColor.clear
        
        let newSelect = collectionView.cellForItem(at: indexPath) as! FilterSearch
        newSelect.filterView.backgroundColor = UIColor(named: "Teal")
        newSelect.filterView.borderColor = UIColor.red
        selectedFilter = filter[indexPath.row]
        filterIndex = indexPath.row
    }
}
extension SearchVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedFilter == .filterLocation{
            return locations.count
        } else if selectedFilter == .filterReputedPeople{
            return filteredPeople?.count ?? 0
        }else if selectedFilter == .filterSamaj{
            return filteredSamajs?.count ?? 0
        } else {
            return filteredProfiles?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedFilter == .filterLocation{
            let cell = tableView.dequeueReusableCell(withIdentifier: NibsKey.commonSearchResultIdentifier, for: indexPath) as! CommonSearchResult
            let user = filteredProfiles?[indexPath.row]
            cell.searchImage.kf.setImage(with: URL(string: user?.profilepicture ?? ""))
            cell.searchTitle.text = user?.getFullName()
    //        cell.searchLocation.text = locations[indexPath.row].getLocation()
            return cell
        } else if selectedFilter == .filterReputedPeople{
            let cell = tableView.dequeueReusableCell(withIdentifier: NibsKey.commonSearchResultIdentifier, for: indexPath) as! CommonSearchResult
            let user = filteredPeople?[indexPath.row]
            cell.searchImage.kf.setImage(with: URL(string: user?.images.first ?? ""))
            cell.searchTitle.text = user?.name
    //        cell.searchLocation.text = locations[indexPath.row].getLocation()
            return cell
        }else if selectedFilter == .filterSamaj{
            let cell = tableView.dequeueReusableCell(withIdentifier: NibsKey.commonSearchResultIdentifier, for: indexPath) as! CommonSearchResult
            let user = filteredSamajs?[indexPath.row]
            cell.searchImage.kf.setImage(with: URL(string: user?.images.first ?? ""))
            cell.searchTitle.text = user?.name
    //        cell.searchLocation.text = locations[indexPath.row].getLocation()
            return cell
        }  else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NibsKey.commonSearchResultIdentifier, for: indexPath) as! CommonSearchResult
            let user = filteredProfiles?[indexPath.row]
            cell.searchImage.kf.setImage(with: URL(string: user?.profilepicture ?? ""))
            cell.searchTitle.text = user?.getFullName()
    //        cell.searchLocation.text = locations[indexPath.row].getLocation()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(82)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedFilter{
        case .filterAll:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.profileViewScreen) as? ProfileViewVC
            vc?.userData = filteredProfiles?[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        case .filterSurname:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.profileViewScreen) as? ProfileViewVC
            vc?.userData = filteredProfiles?[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        case .filterProfile:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.profileViewScreen) as? ProfileViewVC
            vc?.userData = filteredProfiles?[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        case .filterLocation:
            self.view.makeToast("This Feature is Comming Soon")
        case .filterReputedPeople:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.reputedPeopleProfileScreen) as? ReputedPeopleProfileVC
            vc?.profile = filteredPeople?[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        case .filterOccupation:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.profileViewScreen) as? ProfileViewVC
            vc?.userData = filteredProfiles?[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        case .filterSamaj:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.samajDetailsScreen) as? SamajDetailVC
            vc?.samaj = filteredSamajs?[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
