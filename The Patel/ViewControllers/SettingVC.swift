//
//  SettingVC.swift
//  The Patel
//
//  Created by Akash on 19/03/24.
//

import UIKit

class SettingVC: UIViewController {

    var user: UserProfile?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
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
    
    @IBAction func backButtonClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logOutClicked(_ sender: UIControl){
        UserDefaults.standard.removeObject(forKey: UserSession.user)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.loginScreen) as? LoginVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func editProfileCliked(_ sender: UIControl){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.editProfileScreen) as? EditProfileVC
        vc?.user = user
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}
