//
//  FirestoreHelper.swift
//  The Patel
//
//  Created by Akash on 26/02/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

// MARK: Firestore Collections Names
enum FirebaseCollectionName : String{
    case User = "users"
    case Event = "events"
    case Samaj = "samaj"
    case reputedPeople = "reputedpeople"
    case publicDiscussion = "publicdiscussion"
    case messages = "messages"
}

// MARK: Firestore Methods
class FirestoreManager{
    static let shared = FirestoreManager()
    let db = Firestore.firestore()
    private init(){}
    
    // Method For insert new Document or Update data of Document using merge true
    func setDocument(collection: FirebaseCollectionName, key: String, data: [String:Any],merge: Bool = false, complationHandler: @escaping (Bool,String?) -> Void){
        db.collection(collection.rawValue).document(key).setData(data,merge: merge) { error in
            if let error = error {
                complationHandler(false,error.localizedDescription)
            } else {
                complationHandler(true,nil)
            }
        }
    }
    
    // Get Unique id from firestore collection
    func getUniqueID(collection: FirebaseCollectionName) -> String{
        return db.collection(collection.rawValue).document().documentID
    }
    
    // get documents with filter and sort
    func getFilteredDocuments(collection: FirebaseCollectionName, id: String, key: String, complationHandler: @escaping (Bool, String?, [[String:Any]]?) -> Void){
        db.collection(collection.rawValue).whereField(ModelKey.discussionId, isEqualTo: id).order(by: key).getDocuments(completion: { querySnapshot, error in
            if let documents = querySnapshot?.documents{
                var arrDocument: [[String:Any]] = []
                for document in documents{
                    arrDocument.append(document.data())
                }
                complationHandler(true,nil,arrDocument)
            } else { complationHandler(false,error?.localizedDescription,nil) }
        })
    }
    
    // set Listner on collection with any field and get it in order by message date
    func setDocumentListner(collection: FirebaseCollectionName, field: String, value: Any, complationHandler: @escaping (Bool,String?,[[String:Any]]?) -> Void){
        db.collection(collection.rawValue).whereField(field, isEqualTo: value).order(by: ModelKey.messageTime).addSnapshotListener({ querySnapshot, error in
            guard let documents = querySnapshot?.documents else { complationHandler(false,error?.localizedDescription,nil); return }
            var data: [[String:Any]] = []
            for document in documents {
                data.append(document.data())
            }
            complationHandler(true,nil,data)
        })
    }
    
    // Method for get all document from firestore collection
    func getDocuments(collection: FirebaseCollectionName, complationHandler: @escaping (Bool,String?,[[String:Any]]?) -> Void){
       db.collection(collection.rawValue).getDocuments(completion: { (querySnapshot, error) in
           if let documents = querySnapshot?.documents {
                var arrDocument: [[String:Any]] = []
                for document in documents {
                    arrDocument.append(document.data())
                }
                complationHandler(true,nil,arrDocument)
            }
            else{
                complationHandler(false,error?.localizedDescription,nil)
            }
        })
    }
    
    // Method for get particular document from firestore collection
    func getDocument(collection: FirebaseCollectionName, name: String, complationHandler: @escaping (Bool,String?,[String:Any]?) -> Void){
        if name == ""{
            complationHandler(false,HelperKey.errorRequire,nil)
            return
        }
        db.collection(collection.rawValue).document(name).getDocument(completion: { (document, error) in
            if let json = document?.data(){
                complationHandler(true,nil,json)
            }
            else{
                complationHandler(false,error?.localizedDescription,nil)
            }
        })
    }
    
    // Method for get particular document by its key value filter from firestore collection
    func getDocumentByKeyValue(collection: FirebaseCollectionName, key: String, value: Any, complationHandler: @escaping (Bool,String?,[[String:Any]]?) -> Void){
        var data: [[String:Any]] = []
        db.collection(collection.rawValue).whereField(key, isEqualTo: value).getDocuments(completion: { (querySnapshot, error) in
            if let documents = querySnapshot?.documents{
                for document in documents{
                    data.append(document.data())
                }
                if !data.isEmpty{
                    complationHandler(true,nil,data)
                } else {
                    complationHandler(false,error?.localizedDescription,nil)
                }
            }
        })
    }
}
