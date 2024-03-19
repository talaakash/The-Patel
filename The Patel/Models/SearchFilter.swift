//
//  SearchFilter.swift
//  The Patel
//
//  Created by Akash on 06/03/24.
//

import Foundation
import UIKit
import CoreLocation

enum SelectedFilter: String{
    case filterAll = "All"
    case filterSurname = "Surname"
    case filterProfile = "Profile"
    case filterLocation = "Location"
    case filterReputedPeople = "Reputed People"
    case filterOccupation = "Occupation"
    case filterSamaj = "Samajs"
}

class SearchFilter{
    static let shared = SearchFilter()
    private init(){}
    func getSearchFilter() -> [SelectedFilter]{
        return [SelectedFilter.filterAll, SelectedFilter.filterProfile, SelectedFilter.filterSurname, SelectedFilter.filterLocation, SelectedFilter.filterReputedPeople, SelectedFilter.filterOccupation, SelectedFilter.filterSamaj]
    }
    func getFilterColor() -> [UIColor]{
        return [UIColor.darkGray,UIColor.gray,UIColor.blue,UIColor.red,UIColor.purple,UIColor.brown,UIColor.orange]
    }
    
    func filterByName(key: String,profiles: [UserProfile]) -> [UserProfile]?{
        var filteredUser: [UserProfile] = []
        for user in profiles{
            if user.getFullName().lowercased().contains(key.lowercased()){
                filteredUser.append(user)
            }
        }
        
        return filteredUser
    }
    
    func filterBySurname(key: String,profiles: [UserProfile]?) -> [UserProfile]?{
        var filteredUser: [UserProfile] = []
        for user in profiles ?? []{
            if let surname = user.surname{
                if surname.lowercased().contains(key.lowercased()){
                    filteredUser.append(user)
                }
            }
        }
        return filteredUser
    }
    
    func filterByReputedPeople(key: String, profile: [ReputedPeople]?) -> [ReputedPeople]?{
        var filteredPeople: [ReputedPeople] = []
        for people in profile ?? []{
            if people.name.lowercased().contains(key.lowercased()){
                filteredPeople.append(people)
            }
        }
        return filteredPeople
    }
    
    func filterBySamaj(key: String, samajas: [Samaj]?) -> [Samaj]?{
        var filteredSamajs: [Samaj] = []
        for samaj in samajas ?? []{
            if samaj.name.lowercased().contains(key.lowercased()){
                filteredSamajs.append(samaj)
            }
        }
        return filteredSamajs
    }
    
    func filterByOcuupation(key: String, profiles: [UserProfile]) -> [UserProfile]?{
        var filteredUser: [UserProfile] = []
        for user in profiles{
            if let occupation = user.occupation{
                if let title = occupation[ModelKey.occupationTitle], let description = occupation[ModelKey.occupationDescription]{
                    if title.lowercased().contains(key.lowercased()) || description.lowercased().contains(key.lowercased()){
                        filteredUser.append(user)
                    }
                }
            }
        }
        return filteredUser
    }
    
    func getLocation(profiles: [UserProfile], complationHandler: @escaping ([Location]?) -> Void){
        var locations: [Location] = []
        for index in 0..<profiles.count{
            if let location = profiles[index].currentLocation{
                LocationManager.get.locationFromCordinate(latitude: location[0], longitude: location[1], complationHandler: { locationData,error in
                    if error == nil{
                        if let data = locationData{
                            locations.append(data)
                        }
                    }
                    if locations.count == profiles.count{
                        complationHandler(locations)
                    }
                })
            }
        }
    }
}
