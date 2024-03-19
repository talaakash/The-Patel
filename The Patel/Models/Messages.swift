//
//  Messages.swift
//  The Patel
//
//  Created by Akash on 12/03/24.
//

import Foundation
import FirebaseFirestoreInternal

class Messages: Codable{
    let id: String
    let message: String
    let isMessage: Bool
    let messageTime: Date
    let senderId: String
    
    init(json: [String:Any]){
        self.id = json[ModelKey.discussionId] as? String ?? ""
        self.message = json[ModelKey.message] as? String ?? ""
        self.isMessage = json[ModelKey.isMessage] as? Bool ?? true
        let date = json[ModelKey.messageTime] as? Timestamp
        self.messageTime = date?.dateValue() ?? Date()
        self.senderId = json[ModelKey.sender] as? String ?? ""
    }
    
//    func printData(){
//        print("id:\(id) message:\(message) sender:\(senderId)")
//    }
}
