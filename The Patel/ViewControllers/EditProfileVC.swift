//
//  EditProfileVC.swift
//  The Patel
//
//  Created by Akash on 19/03/24.
//

import UIKit
import Toast_Swift

class EditProfileVC: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var surname: UITextField!
    @IBOutlet weak var birthDate: UIDatePicker!
    var user: UserProfile?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        profilePicture.kf.setImage(with: URL(string: user?.profilepicture ?? ""))
        name.text = user?.name
        surname.text = user?.surname
        birthDate.date = user?.birthdate ?? Date()
        
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
    
    @IBAction func imageChange(_ sender: UIControl){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func performUpdate(_ sender: UIButton){
        guard let user = UserDefaults.standard.object(forKey: UserSession.user) as? [String:Any] else { return }
        guard let userid = user[UserSession.userID] as? String else { return }
        guard let name = name.text, let surname = surname.text else { self.view.makeToast(ErrorKey.invalidDetails); return }
        ProgressBar.shared.show()
        FirebaseStorageManager.shared.storeData(type: .ProfilePicture, image: profilePicture.image ?? UIImage(), complationHandler: { [self] status, error, url in
            if status == true{
                let stringUrl = url?.absoluteString
                FirestoreManager.shared.setDocument(collection: .User, key: userid, data: [ModelKey.profilePic: stringUrl ?? "", ModelKey.name: name, ModelKey.surname: surname, ModelKey.birthDate: birthDate.date], merge: true, complationHandler: { status, error in
                    if status == true{
                        ProgressBar.shared.hide()
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        ProgressBar.shared.hide()
                        self.view.makeToast(error)
                    }
                })
            } else {
                ProgressBar.shared.hide()
                self.view.makeToast(error)
            }
        })
    }
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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

