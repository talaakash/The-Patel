//
//  LoginVC.swift
//  The Patel
//
//  Created by Akash on 23/02/24.
//

import UIKit
import Toast_Swift
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func login(_ sender: UIButton){
        guard let email = txtEmail.text,let password = txtPassword.text else{
            self.view.makeToast(ErrorKey.invalidDetails)
            return
        }
        var isError = false
        if !email.validateInput(type: .email){
            isError = true
            txtEmail.layer.borderColor = UIColor.red.cgColor
        }
        if !password.validateInput(type: .password){
            isError = true
            txtPassword.layer.borderColor = UIColor.red.cgColor
        }
        if isError {
            self.view.makeToast(ErrorKey.invalidDetails)
            return
        }
        ProgressBar.shared.show()
        FirebaseAuthManager.shared.login(email: email, password: password, complationhandler: { status,user,error  in
            if status == true{
                UserDefaults.standard.set([UserSession.userID:user?.uid, UserSession.email:user?.email], forKey: UserSession.user)
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
            }
            else{
                self.view.makeToast(error)
            }
        })
    }
    
    @IBAction func createAccount(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.signupScreen) as? SignupVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension LoginVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.borderColor = UIColor.systemGray
    }
}
