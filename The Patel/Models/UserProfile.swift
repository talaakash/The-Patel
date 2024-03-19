//
//  User.swift
//  The Patel
//
//  Created by Akash on 26/02/24.
//

import Foundation

class UserProfile{
    let name: String?
    let surname: String?
    let number: Int?
    let email: String?
    let profilepicture: String?
    let currentLocation: [Double]?
    let nativeLocation: [Double]?
    let birthdate: String?
    let education: [String:String]?
    let occupation: [String:String]?
    
    init(json : [String:Any]) {
        self.name = json[ModelKey.name] as? String
        self.surname = json[ModelKey.surname] as? String
        self.number = json[ModelKey.number] as? Int
        self.email = json[ModelKey.email] as? String
        self.profilepicture = json[ModelKey.profilePic] as? String
        self.currentLocation = json[ModelKey.currentLocation] as? [Double]
        self.nativeLocation = json[ModelKey.nativeLocation] as? [Double]
        self.birthdate = json[ModelKey.birthDate] as? String
        self.education = json[ModelKey.education] as? [String:String]
        self.occupation = json[ModelKey.occupation] as? [String:String]
    }
    
    func getFullName() -> String{
        return "\(self.name ?? "") \(self.surname ?? "")"
    }
    
    func getJson() -> [String:Any]{
        return [ModelKey.name:name ?? "",ModelKey.surname:surname ?? "",ModelKey.number: number ?? 0,ModelKey.profilePic: profilepicture ?? "",ModelKey.currentLocation: currentLocation ?? 0.0,ModelKey.nativeLocation:nativeLocation ?? 0.0,ModelKey.birthDate: birthdate ?? Date(),ModelKey.education: education ?? [String:String].self,ModelKey.occupation: occupation ?? [String:String].self]
    }
}
