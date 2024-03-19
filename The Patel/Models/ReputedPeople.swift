//
//  ReputedPeople.swift
//  The Patel
//
//  Created by Akash on 07/03/24.
//

import Foundation
import FirebaseFirestoreInternal

class ReputedPeople{
    let name: String
    let description: String
    let images: [String]
    let latitude: Double
    let longitude: Double
    let birthDate: Date
    let business: String
    let awards: [String]
    
    init(json: [String:Any]){
        self.name = json[ModelKey.reputedPeopleName] as? String ?? ""
        self.description = json[ModelKey.reputedPeopleDescription] as? String ?? ""
        self.images = json[ModelKey.reputedPeopleImages] as? [String] ?? []
        self.awards = json[ModelKey.reputedPeopleAwards] as? [String] ?? []
        self.latitude = json[ModelKey.reputedPeopleLatitude] as? Double ?? 0.0
        self.longitude = json[ModelKey.reputedPeopleLongitude] as? Double ?? 0.0
        let date = json[ModelKey.reputedPeopleBirthdate] as? Timestamp
        self.birthDate = date?.dateValue() ?? Date()
        self.business = json[ModelKey.reputedPeopleBusiness] as? String ?? ""
    }
}
