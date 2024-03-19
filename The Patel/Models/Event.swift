//
//  Event.swift
//  The Patel
//
//  Created by Akash on 01/03/24.
//

import Foundation

class Event{
    let id: String
    let createDate: String
    let name: String
    let description: String
    let organizer: String
    let latitude: Double
    let longitude: Double
    let dateandtime: String
    let chiefGuest: [String]
    let guest: [String]
    let images: [String]
    
    init(json: [String:Any]) {
        self.id = json[ModelKey.id] as? String ?? ""
        self.createDate = json[ModelKey.createDate] as? String ?? ""
        self.name = json[ModelKey.eventName] as? String ?? ""
        self.description = json[ModelKey.eventDescription] as? String ?? ""
        self.organizer = json[ModelKey.organizer] as? String ?? ""
        self.latitude = json[ModelKey.latitude] as? Double ?? 0.0
        self.longitude = json[ModelKey.longitude] as? Double ?? 0.0
        self.dateandtime = json[ModelKey.dateandtime] as? String ?? ""
        self.chiefGuest = json[ModelKey.chiefGuest] as? [String] ?? []
        self.guest = json[ModelKey.guest] as? [String] ?? []
        self.images = json[ModelKey.Images] as? [String] ?? []
    }
}
