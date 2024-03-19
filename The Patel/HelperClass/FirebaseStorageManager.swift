//
//  FirebseStorageManager.swift
//  The Patel
//
//  Created by Akash on 26/02/24.
//

import Foundation
import FirebaseStorage

enum ImageType: String{
    case ProfilePicture = "ProfilePic"
    case EventPicture = "EventPicture"
    case SamajPicture = "SamajPicture"
    case Discussion = "Discussion"
    case Message = "Message"
    case ReputedPeople = "ReputedPeople"
}

class FirebaseStorageManager{
    static let shared = FirebaseStorageManager()
    private init(){}
    
    func storeData(type: ImageType, image: UIImage, complationHandler: @escaping (Bool,String?,URL?) -> Void){
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("\(type.rawValue)/\(imageName).jpg")
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    complationHandler(false,error.localizedDescription,nil)
                    return
                }
                storageRef.downloadURL(completion: { url, error in
                    if let downloadUrl = url{
                        complationHandler(true,nil,downloadUrl)
                    } else {
                        complationHandler(false,ErrorKey.errorMessage,nil)
                    }
                })
            }
        }
    }
}
