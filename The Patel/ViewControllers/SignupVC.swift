//
//  SignupVC.swift
//  The Patel
//
//  Created by Akash on 23/02/24.
//

import UIKit
import Photos
import Toast_Swift
import FirebaseAuth

class SignupVC: UIViewController{

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtSurname: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var user: UserProfile?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePanGesture(_:)))
        edgePanGesture.edges = .left
        view.addGestureRecognizer(edgePanGesture)
    }
    
    @objc func handleEdgePanGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .ended {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func signUp(_ sender: UIButton){
        guard let name = txtName.text,let email = txtEmail.text,let number = txtNumber.text,let surname = txtSurname.text,let password = txtPassword.text,let confirmPassword = txtConfirmPassword.text,name != "", surname != "", number != "", password != "" else{
            self.view.makeToast(ErrorKey.invalidDetails)
            return
        }
        var isError = false
        if password != confirmPassword{
            isError = true
        }
        if !email.validateInput(type: .email){
            isError = true
            txtEmail.layer.borderColor = UIColor.red.cgColor
        }
        if !password.validateInput(type: .password){
            isError = true
            txtPassword.layer.borderColor = UIColor.red.cgColor
            txtConfirmPassword.layer.borderColor = UIColor.red.cgColor
        }
        if isError{
            self.view.makeToast(ErrorKey.invalidDetails)
            return
        }
        
        ProgressBar.shared.show()
        FirebaseAuthManager.shared.createUser(email: email, password: password, complationHandler: { status,user,error in
            if status == true{
                UserDefaults.standard.set([UserSession.userID:user?.uid, UserSession.email:user?.email], forKey: UserSession.user)
                FirebaseStorageManager.shared.storeData(type: .ProfilePicture, image: self.profilePicture.image ?? UIImage(), complationHandler: { status,error,url in
                    if status == true{
                        guard let user = UserDefaults.standard.object(forKey: UserSession.user) as? [String:Any] else { return }
                        guard let userid = user[UserSession.userID] as? String else { return }
                        FirestoreManager.shared.setDocument(collection: .User, key: userid, data: [ModelKey.name:name,ModelKey.surname:surname,ModelKey.number:number,ModelKey.email:email,ModelKey.profilePic:String(describing: url ?? URL(fileURLWithPath: ""))], complationHandler: { status,error in
                            ProgressBar.shared.hide()
                            if status == false{
                                self.view.makeToast(error)
                            }
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.userInfoGettingScreen) as? UserInfoGettingVC
                            self.navigationController?.pushViewController(vc!, animated: true)
                        })
                    }
                })
            }
        })

    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func profilePicChange(_ sender: UIControl){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
}

extension SignupVC: UITextFieldDelegate ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.borderColor = UIColor.systemGray
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profilePicture.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
