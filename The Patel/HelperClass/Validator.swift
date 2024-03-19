//
//  CredentialValidator.swift
//  FirebasePractice
//
//  Created by Akash on 22/02/24.
//

import Foundation

enum Regx : String{
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    case password = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{6,}$"
}

extension String {
    func validateInput(type: Regx) -> Bool{
        return Validator.validateInput(type: type, value: self)
    }
}

class Validator{
    static func validateInput(type: Regx, value: String) -> Bool{
        let predicate = NSPredicate(format: "SELF MATCHES %@", type.rawValue)
        return predicate.evaluate(with: value)
    }
}
