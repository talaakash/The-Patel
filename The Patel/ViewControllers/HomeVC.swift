//
//  HomeVC.swift
//  The Patel
//
//  Created by Akash on 27/02/24.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var birthDate: UILabel!
    var userData: UserProfile?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        userName.text = "\(userData?.name ?? "") \(userData?.surname ?? "")"
        profilePic.kf.setImage(with: URL(string: userData?.profilepicture ?? ""))
        birthDate.text = "Born on \(userData?.birthdate?.getDate() ?? "")"
    }

    @IBAction func viewProfile(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.profileViewScreen) as? ProfileViewVC
        vc?.userData = userData
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func eventClicked(_ sender: UIControl) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.eventScreen) as? EventVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func searchClicked(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.searchScreen) as? SearchVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func publicDiscussionClicked(_ sender: UIControl){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.publicDiscussionScreen) as? PublicDiscussionVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func patelSamajsClicked(_ sender: UIControl){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.patelSamajsScreen) as? PatelSamajsVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func reputedPeopleClicked(_ sender: UIControl){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.reputedPeopleScreen) as? ReputedPeopleVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func settings(_ sender: UIButton){
        UserDefaults.standard.removeObject(forKey: UserSession.user)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.loginScreen) as? LoginVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
