//
//  DataHandler.swift
//  The Patel
//
//  Created by Akash on 19/03/24.
//

import Foundation

class DataHandler{
    static let shared = DataHandler()
    private init() {}
    
    func setData<T: Encodable>(model: T.Type, key: String, data: Any){
        let arrData = data as? [T]
        if let json = try? JSONEncoder().encode(arrData){
            UserDefaults.standard.setValue(json, forKey: key)
        }
    }
    
    func getData<T: Decodable>(model: T.Type, key: String) -> [T]?{
        let list = UserDefaults.standard.value(forKey: key) as? Data ?? Data()
        if let jsonToObject = try? JSONDecoder().decode([T].self, from: list){
            return jsonToObject
        }
        return nil
    }
    
    func setJson(key: String, json: [String:String]){
        UserDefaults.standard.setValue(json, forKey: key)
    }
    
    func getJson(key: String) -> [String:String]?{
        if let json = UserDefaults.standard.value(forKey: key) as? [String:String]{
            return json
        }
        return nil
    }
}
