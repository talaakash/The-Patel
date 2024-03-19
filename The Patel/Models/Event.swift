//
//  Event.swift
//  The Patel
//
//  Created by Akash on 01/03/24.
//

import Foundation
import FirebaseFirestoreInternal

class Event: Codable{
    let id: String
    let createDate: Date
    let name: String
    let description: String
    let organizer: String
    let latitude: Double
    let longitude: Double
    let dateandtime: Date
    let chiefGuest: [String]
    let guest: [String]
    let images: [String]
    
    init(json: [String:Any]) {
        self.id = json[ModelKey.id] as? String ?? ""
        var date = json[ModelKey.createDate] as? Timestamp
        self.createDate = date?.dateValue() ?? Date()
        self.name = json[ModelKey.eventName] as? String ?? ""
        self.description = json[ModelKey.eventDescription] as? String ?? ""
        self.organizer = json[ModelKey.organizer] as? String ?? ""
        self.latitude = json[ModelKey.latitude] as? Double ?? 0.0
        self.longitude = json[ModelKey.longitude] as? Double ?? 0.0
        date = json[ModelKey.dateandtime] as? Timestamp
        self.dateandtime = date?.dateValue() ?? Date()
        self.chiefGuest = json[ModelKey.chiefGuest] as? [String] ?? []
        self.guest = json[ModelKey.guest] as? [String] ?? []
        self.images = json[ModelKey.Images] as? [String] ?? []
    }
}
