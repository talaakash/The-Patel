//
//  PublicDiscussion.swift
//  The Patel
//
//  Created by Akash on 12/03/24.
//

import Foundation
import FirebaseFirestoreInternal

class PublicDiscussion: Codable{
    let id: String?
    let image: String?
    let topic: String?
    let createDate: Date?
    let creator: String?
    let lastIsMessage: Bool?
    let lastMessage: String?
    let lastMessageTime: Date?
    let lastMessageSender: String?
    
    init(json: [String:Any]){
        self.id = json[ModelKey.discussionId] as? String ?? ""
        self.image = json[ModelKey.discussionImage] as? String ?? ""
        self.topic = json[ModelKey.topic] as? String ?? ""
        var time = json[ModelKey.DiscussionCreateDate] as? Timestamp
        self.createDate = time?.dateValue()
        self.creator = json[ModelKey.creator] as? String ?? ""
        self.lastIsMessage = json[ModelKey.isMessage] as? Bool ?? true
        self.lastMessage = json[ModelKey.lastMessage] as? String ?? ""
        time = json[ModelKey.messageTime] as? Timestamp
        self.lastMessageTime = time?.dateValue()
        self.lastMessageSender = json[ModelKey.sender] as? String ?? ""
    }
}
