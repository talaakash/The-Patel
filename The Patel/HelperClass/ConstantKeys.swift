//
//  ConstantKey.swift
//  The Patel
//
//  Created by Akash on 01/03/24.
//

import Foundation

class UserSession{
    static let user = "User"
    static let email = "Email"
    static let userID = "UserId"
    
    static let events = "EventsList"
    static let samajs = "SamjsList"
    static let locationForSamajs = "SamajsLocation"
    static let publicDiscussion = "PublicDiscussion"
    static let reputedPeople = "ReputedPeople"
    static let messages = "Messages"
    static let images = "Images"
}

class ViewControllerKey{
    static let navigationController = "NavigationController"
    static let homeScreen = "HomeVC"
    static let loginScreen = "LoginVC"
    static let signupScreen = "SignupVC"
    static let forgetPasswordScreen = "ForgetPasswordVC"
    static let userInfoGettingScreen = "UserInfoGettingVC"
    static let profileViewScreen = "ProfileViewVC"
    static let eventScreen = "EventVC"
    static let sceduleEventScreen = "SceduleEventVC"
    static let popUpGuestSelectorScreen = "PopUpguestSelectorVC"
    static let eventDetailsScreen = "EventDetailsVC"
    static let searchScreen = "SearchVC"
    static let patelSamajsScreen = "PatelSamajsVC"
    static let addSamajScreen = "AddSamajVC"
    static let samajDetailsScreen = "SamajDetailVC"
    static let publicDiscussionScreen = "PublicDiscussionVC"
    static let createDiscussionScreen = "CreateDiscussionVC"
    static let chatScreen = "ChatScreenVC"
    static let reputedPeopleScreen = "ReputedPeopleVC"
    static let addReputedPeopleScreen = "AddReputedPeopleVC"
    static let reputedPeopleProfileScreen = "ReputedPeopleProfileVC"
    static let settingScreen = "SettingVC"
    static let editProfileScreen = "EditProfileVC"
}

class NibsKey{
    static let guestProfile = "GuestProfile"
    static let guestProfileIdentifier = "GuestProfile"
    static let eventImage = "EventImages"
    static let eventImageIdentifier = "EventImages"
    static let event = "Events"
    static let eventIdentifier = "Events"
    static let chiefGuest = "ChiefGuest"
    static let chiefGuestIdentifier = "ChiefGuest"
    static let eventImagesCollection = "EventImagesCollection"
    static let eventImagesCollectionIdentifier = "EventImages"
    static let searchFilter = "FilterSearch"
    static let searchFilterIdentifier = "SearchFilter"
    static let commonSearchResult = "CommonSearchResult"
    static let commonSearchResultIdentifier = "CommonSearch"
    static let patelSamajList = "SamajsList"
    static let patelSamajListIdentifier = "SamajsList"
    static let publicDiscussion = "PublicDiscussions"
    static let publicDiscussionIdentifier = "PublicDiscussion"
    static let othersMessage = "OthersMessage"
    static let othersMessageIdentifier = "OthersMessage"
    static let ourMessage = "OurMessage"
    static let ourMessageIdentifier = "OurMessage"
    static let sendingMessage = "SendingMessage"
    static let sendingMessageIdentifier = "SendingMessage"
    static let othersImage = "OthersImage"
    static let othersImageIdentifier = "OthersImage"
    static let ourImage = "OurImage"
    static let ourImageIdentifier = "OurImage"
    static let sendingImage = "SendingImage"
    static let sendingImageIdentifier = "SendingImage"
}

class ErrorKey{
    static let invalidDetails = "Enter valid details"
    static let errorMessage = "Something went wrong"
    static let noValue = "No Message Found"
}

class LocationKey{
    static let nativePlace = "Native Place"
    static let venuePlace = "Venue Place"
    static let patelSamaj = "Patel Samaj"
    static let settingAlertTitle = "Settings"
    static let locationAlertTitle = "Location Access Denied"
    static let locationAlertMessage = "Please enable location services for better experience."
    static let enterLocation = "Enter valid location"
}

class ModelKey{
    // User Model
    static let name = "Name"
    static let surname = "Surname"
    static let number = "Number"
    static let email = "Email"
    static let profilePic = "Profile Picture"
    static let birthDate = "Birth Date"
    static let education = "Education"
    static let educationTitle = "Education Title"
    static let educationDescription = "Education Description"
    static let occupation = "Occupation"
    static let occupationTitle = "Ocuupation Title"
    static let occupationDescription = "Occupation Description"
    static let currentLocation = "Current Location"
    static let nativeLocation = "Native Location"
    static let userDateFormat = "dd MMM yyyy"
    
    // Event Model
    static let id = "Event Id"
    static let createDate = "Create Date"
    static let eventName = "Event Name"
    static let eventDescription = "Event Description"
    static let organizer = "Organizer"
    static let latitude = "Latitude"
    static let longitude = "Longitude"
    static let dateandtime = "Date And Time"
    static let chiefGuest = "Chief Guest"
    static let guest = "Guests"
    static let Images = "Images"
    static let notificationIdentifier = "EventAlert"
    static let dateandtimeFormat = "yyyy-MM-dd HH:mm:ss"
    
    // Samaj Model
    static let samajName = "Name"
    static let samajDescription = "Description"
    static let samajFacilities = "Facilities"
    static let samajImages = "Images"
    static let samajLatitude = "Latitude"
    static let samajLongitude = "Longitude"
    
    // Reputed People Model
    static let reputedPeopleName = "Name"
    static let reputedPeopleDescription = "Description"
    static let reputedPeopleImages = "Images"
    static let reputedPeopleAwards = "Awards"
    static let reputedPeopleLatitude = "Latitude"
    static let reputedPeopleLongitude = "Longitude"
    static let reputedPeopleBirthdate = "BirthDate"
    static let reputedPeopleBusiness = "Business"
    
    // Public Discussion model
    static let discussionId = "Id"
    static let discussionImage = "Image"
    static let topic = "Topic"
    static let DiscussionCreateDate = "Create Date"
    static let creator = "Creator"
    static let isMessage = "Last Is Message?"
    static let lastMessage = "Last Message"
    static let message = "Message"
    static let messageTime = "Message Date"
    static let sender = "Sender Id"
    static let timeFormat = "HH:mm"
}

class ImagesKey{
    static let eye = "eye"
    static let eyeSlash = "eye.slash"
}

class HelperKey{
    static let errorRequire = "Document id is required"
    static let version = "AppVersion"
    static let systemVersion = "CFBundleShortVersionString"
}

class AlertBox{
    static let title = "Alert"
    static let mailSended = "Email send successfully Please reset Password"
    static let logoutTiltle = "Conformation"
    static let logoutMessage = "Are you Sure You Want LogOut"
    static let yes = "Yes"
    static let no = "No"
    static let action = "Okay"
}

class DatesFormates{
    static let dateFormat = "dd MMM yyyy"
    static let timeFormat = "h:mm a"
}
