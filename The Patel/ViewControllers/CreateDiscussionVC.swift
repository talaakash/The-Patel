//
//  CreateDiscussionVC.swift
//  The Patel
//
//  Created by Akash on 12/03/24.
//

import UIKit

class CreateDiscussionVC: UIViewController{

    @IBOutlet weak var discussionTitle: UITextField!
    @IBOutlet weak var discussionImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func imageUpload(_ sender: UIControl){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createDiscussion(_ sender: UIButton){
        guard let name = discussionTitle.text else { self.view.makeToast(ErrorKey.invalidDetails); return }
        if name == ""{ self.view.makeToast(ErrorKey.invalidDetails); return }
        if let image = discussionImage.image{
            var urlString = ""
            ProgressBar.shared.show()
            FirebaseStorageManager.shared.storeData(type: .Discussion, image: image, complationHandler: { status, error, imageUrl in
                if status == true{
                    if let url = imageUrl{
                        urlString = String(describing: url)
                        guard let user = UserDefaults.standard.object(forKey: UserSession.user) as? [String:Any] else { return }
                        guard let userid = user[UserSession.userID] as? String else { return }
                        let key = FirestoreManager.shared.getUniqueID(collection: .publicDiscussion)
                        FirestoreManager.shared.setDocument(collection: .publicDiscussion, key: key, data: [ModelKey.discussionId: key, ModelKey.discussionImage: urlString, ModelKey.topic: name, ModelKey.DiscussionCreateDate: Date(), ModelKey.creator: userid, ModelKey.isMessage: true, ModelKey.lastMessage: "", ModelKey.messageTime: Date(), ModelKey.sender: ""], complationHandler: { status, error in
                            ProgressBar.shared.hide()
                            if status == true{
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                self.view.makeToast(error)
                            }
                        })
                    }
                } else {
                    ProgressBar.shared.hide()
                    self.view.makeToast(error)
                }
            })
        }
    }
}

extension CreateDiscussionVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            discussionImage.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
