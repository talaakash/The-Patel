//
//  Samaj.swift
//  The Patel
//
//  Created by Akash on 07/03/24.
//

import Foundation

class Samaj{
    let name: String
    let description: String
    let facilities: [String]
    let images: [String]
    let latitude: Double
    let longitude: Double
    
    init(json: [String:Any]) {
        self.name = json[ModelKey.samajName] as? String ?? ""
        self.description = json[ModelKey.samajDescription] as? String ?? ""
        self.facilities = json[ModelKey.samajFacilities] as? [String] ?? []
        self.images = json[ModelKey.samajImages] as? [String] ?? []
        self.latitude = json[ModelKey.samajLatitude] as? Double ?? 0.0
        self.longitude = json[ModelKey.samajLongitude] as? Double ?? 0.0
    }
}
