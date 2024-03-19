//
//  ViewController.swift
//  The Patel
//
//  Created by Akash on 23/02/24.
//

import UIKit
import SVProgressHUD

class UserCheckingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup(){
        FirebaseRemoteConfig.shared.activeRemoteConfig()
        if let appVersion = Bundle.main.infoDictionary?[HelperKey.systemVersion] as? String {
            if !FirebaseRemoteConfig.shared.validateVersion(appVersion: appVersion){
                self.view.makeToast(ErrorKey.errorMessage)
                return
            }
        } else {
            self.view.makeToast(ErrorKey.errorMessage)
            return
        }
        ProgressBar.shared.show(horizontal: 0,vertical: 350,color: .black)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if UserDefaults.standard.object(forKey: UserSession.user) != nil{
                if let user = UserDefaults.standard.value(forKey: UserSession.user) as? [String:Any]{
                    FirestoreManager.shared.getDocument(collection: .User, name: user[UserSession.userID] as? String ?? "", complationHandler: { status,error,data in
                        ProgressBar.shared.hide()
                        if status == false{
                            self.view.makeToast(error)
                        }
                        else{
                            let userDetails = UserProfile(json: data ?? [:])
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.homeScreen) as? HomeVC
                            vc?.userData = userDetails
                            self.navigationController?.pushViewController(vc!, animated: true)
                        }
                    })
                }
                else{
                    self.view.makeToast(ErrorKey.errorMessage)
                }
            }
            else{
                // Move to Login Page
                ProgressBar.shared.hide()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.loginScreen) as? LoginVC
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
        })
    }

}

