//
//  FirebaseRemoteConfig.swift
//  The Patel
//
//  Created by Akash on 18/03/24.
//

import Foundation
import FirebaseRemoteConfig

class FirebaseRemoteConfig{
    static let shared = FirebaseRemoteConfig()
    let remoteConfig = RemoteConfig.remoteConfig()
    let remoteConfigSettings = RemoteConfigSettings()
    private init(){ }
    
    func activeRemoteConfig(){
        remoteConfigSettings.minimumFetchInterval = 0
        remoteConfig.fetch { (status, error) in
            if status == .success {
                self.remoteConfig.activate { (changed, error) in
            
                }
            }
        }
    }
    
    func validateVersion(appVersion: String) -> Bool{
        let currentVersion = remoteConfig[HelperKey.version].stringValue
        if currentVersion?.compare(appVersion,options: .numeric) == .orderedSame || currentVersion?.compare(appVersion,options: .numeric) == .orderedAscending{
            return true
        }
        return false
    }
}
