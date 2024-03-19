//
//  FirebaseTask.swift
//  FirebasePractice
//
//  Created by Akash on 22/02/24.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager{
    static let shared = FirebaseAuthManager()
    private init(){}
    
    func createUser(email: String, password: String, complationHandler: @escaping (Bool,User?,String?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user{
                complationHandler(true,user,nil)
            }else{
                complationHandler(false,nil,error?.localizedDescription ?? ErrorKey.errorMessage)
            }
        }
    }
    
    func login(email: String, password: String, complationhandler: @escaping (Bool,User?,String?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let user = authResult?.user{
                complationhandler(true,user,nil)
            }else{
                complationhandler(false,nil,error?.localizedDescription ?? ErrorKey.errorMessage)
            }
        }
    }
}
