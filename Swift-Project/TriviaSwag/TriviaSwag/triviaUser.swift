//
//  triviaUser.swift
//  gStack Client Framework
//
//  Created by Evan Bernstein on 8/17/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit
import CoreLocation

public class triviaUser: NSObject {
    var _id: String?
    public var location: triviaUserLocation?
    public var displayName: String?
    var channel: String?
    public var gamesPlayed: NSNumber?
    public var registered: NSDate?
    public var isSuspended: gStackSuspension?

    public var adFreeExpire: NSNumber?
    public var tournamentsPlayed: NSNumber?
    public var tournamentsWon: Array<triviaUserTournament>?
    public var tournamentQuestionsSeen: NSNumber?
    public var tournamentQuestionTime: NSNumber?
    public var tournamentQuestionCorTime: NSNumber?
    public var tournamentQuestionCor: NSNumber?

    public var questionsSeen: NSNumber?
    public var questionsCorrect: NSNumber?
    public var correctTime: NSNumber?
    public var ticketBalance: NSNumber?
    public var categories: Array<gStackCategory>?
    public var lifelines: gStackLifelines?
    public var multiplier: NSNumber?
    public var multiplierExpire: NSDate?
    public var tokensEarned: NSNumber?
    public var timePlayed: NSNumber?
    public var friends: Array<triviaFriend>?
    public var avatar: String?
    public var cover: String?
    public var status: String?
    public var pushSettings: gStackPushSettings?
    public var favoriteTournaments: Array<gStackTournament>?
    public var isVerified: Bool?
    public var isFacebookLinked: Bool?
    public var address: triviaUserAddress?
    public var name: String?
    public var phone: String?
    public var email: String?
    
    deinit{
        
        
    }
    
    init(payload: Dictionary<String,AnyObject>) {
        _id = payload["_id"] as? String
        if let locationDictionary = payload["location"] as? Dictionary<String,AnyObject> {
            location = triviaUserLocation()
            location!.region = locationDictionary["region"] as? String
            location!.country = locationDictionary["country"] as? String
            location!.lat = locationDictionary["lat"] as? String
            location!.long = locationDictionary["long"] as? String
        }
        displayName = payload["displayName"] as? String
        if let isSuspendedDictionary = payload["isSuspended"] as? Dictionary<String,AnyObject> {
            isSuspended = gStackSuspension()
            if let dateString = isSuspendedDictionary["date"] as? String {
                isSuspended!.date = dateForString(dateString)
            }
            if let reasonDictionary = isSuspendedDictionary["reason"] as? Dictionary<String,AnyObject> {
                let reason = gStackSuspensionReason()
                reason.out = reasonDictionary["out"] as? String
                reason.verbose = reasonDictionary["verbose"] as? String
                isSuspended!.reason = reason
            }
            isSuspended!.status = isSuspendedDictionary["status"] as? Bool
            isSuspended!.auth = isSuspendedDictionary["auth"] as? String
        }
        channel = payload["channel"] as? String
        if let dateString = payload["registered"] as? String {
            registered = dateForString(dateString)
        }
        gamesPlayed = payload["gamesPlayed"] as? NSNumber
        adFreeExpire = payload["adFreeExpire"] as? NSNumber
        tournamentsPlayed = payload["tournamentsPlayed"] as? NSNumber
        if let tournamentsWonArray = payload["tournamentsWon"] as? Array<Dictionary<String,AnyObject>> {
            tournamentsWon = Array<triviaUserTournament>()
            for tournamentDictionary in tournamentsWonArray {
                let tournament = triviaUserTournament()
                if let dateString = tournamentDictionary["date"] as? String {
                    tournament.date = dateForString(dateString)
                }
                tournament.image = tournamentDictionary["image"] as? String
                tournament.name = tournamentDictionary["name"] as? String
                tournament.prize = tournamentDictionary["prize"] as? String
                tournament.uuid = tournamentDictionary["uuid"] as? String
                tournamentsWon!.append(tournament)
            }
        }
        tournamentQuestionsSeen = payload["tournamentQuestionsSeen"] as? NSNumber
        tournamentQuestionTime = payload["tournamentQuestionTime"] as? NSNumber
        tournamentQuestionCorTime = payload["tournamentQuestionCorTime"] as? NSNumber
        tournamentQuestionCor = payload["tournamentQuestionCor"] as? NSNumber
        questionsSeen = payload["questionsSeen"] as? NSNumber
        questionsCorrect = payload["questionsCorrect"] as? NSNumber
        correctTime = payload["correctTime"] as? NSNumber
        ticketBalance = payload["ticketBalance"] as? NSNumber
        if let categoriesArray = payload["categories"] as? Array<Dictionary<String,AnyObject>> {
            categories = Array<gStackCategory>()
            for categoryDictionary in categoriesArray {
                let category = gStackCategory()
                category.category = categoryDictionary["category"] as? String
                if let firstPlayedDateString = categoryDictionary["firstPlayed"] as? String {
                    category.firstPlayed = dateForString(firstPlayedDateString)
                }
                if let lastActivityDateString = categoryDictionary["lastActivityDateString"] as? String {
                    category.lastActivity = dateForString(lastActivityDateString)
                }
                category.rating = categoryDictionary["rating"] as? NSNumber
                category.level = categoryDictionary["level"] as? NSNumber
                category.gamesPlayed = categoryDictionary["gamesPlayed"] as? NSNumber
                category.gamesWon = categoryDictionary["gamesWon"] as? NSNumber
                category.winStreak = categoryDictionary["winStreak"] as? NSNumber
                category.lossStreak = categoryDictionary["lossStreak"] as? NSNumber
                category.singleTokens = categoryDictionary["singleTokens"] as? NSNumber
                category.versusTokens = categoryDictionary["versusTokens"] as? NSNumber
                categories!.append(category)
            }
        }
        if let lifelinesDictionary = payload["lifelines"] as? Dictionary<String,AnyObject> {
            lifelines = gStackLifelines(dictionary: lifelinesDictionary)
        }
        multiplier = payload["multiplier"] as? NSNumber
        if let dateString = payload["multiplierExpire"] as? String {
            multiplierExpire = dateForString(dateString)
        }
        tokensEarned = payload["tokensEarned"] as? NSNumber
        timePlayed = payload["timePlayed"] as? NSNumber
        if let friendsArray = payload["friends"] as? Array<Dictionary<String,AnyObject>> {
            friends = Array<triviaFriend>()
            for friendDictionary in friendsArray {
                friends!.append(triviaFriend(dictionary: friendDictionary))
            }
        }
        avatar = payload["avatar"] as? String
        cover = payload["cover"] as? String
        status = payload["status"] as? String
        isVerified = payload["isVerified"] as? Bool
        isFacebookLinked = payload["isFacebookLinked"] as? Bool
        if let addressDict = payload["address"] as? Dictionary<String,AnyObject> {
            address = triviaUserAddress(dictionary: addressDict)
        }
        name = payload["name"] as? String
        phone = payload["phone"] as? String
        email = payload["email"] as? String
        
        if channel != nil {
            triviaNotificationHandler.sharedInstance.subscribeToPushPresentChannel(channel!)
        } else {
            print("No channel: cannot connect to pusher server")
        }
        
    }
    
    convenience override init() {
        self.init(payload: Dictionary<String,AnyObject>())
    }
    

    
    public class func logInFromSavedToken(completion: (error: NSError?) -> Void) {
        retrieveLogInToken()
        if triviaCurrentUser?._id != nil {
            triviaGetCurrentUserInfo(completion)
        } else {
            completion(error: NSError(domain: "No Saved Token", code: 6, userInfo: nil))
        }
    }
    
    
    public class func logOutCurrentUser() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(triviaUserLogInTokenKey)
        NSUserDefaults.standardUserDefaults().synchronize()
//        if let _channel = triviaCurrentUser?.channel{
//            triviaNotificationHandler.sharedInstance.unsubscribeToPusherChannel(_channel)
//        }
        gStackClearCurrentUserInfo()
        triviaNotificationHandler.sharedInstance.pusherClient.disconnect()
        triviaNotificationHandler.sharedInstance.pusherClient = nil
        triviaNotificationHandler.sharedInstance.connectToPusherServer()
        triviaCurrentUserInbox = nil
        triviaCurrentUser = nil
    }
    
    public func isFriendOfCurrentUser(name: String) -> Bool {
        
        for friend in friends! {
            if name == friend.displayName {
                return true
            }
        }
        return false
    }
    
}

public class triviaUserLocation: NSObject {
    public var region: String?
    public var country: String?
    var lat: String? {
        didSet {
            if long != nil && lat != oldValue {
                coordinate = CLLocationCoordinate2DMake((lat! as NSString).doubleValue, (long! as NSString).doubleValue)
            }
        }
    }
    var long: String? {
        didSet {
            if lat != nil && long != oldValue {
                coordinate = CLLocationCoordinate2DMake((lat! as NSString).doubleValue, (long! as NSString).doubleValue)
            }
        }
    }
    
    public var coordinate: CLLocationCoordinate2D? {
        didSet {
            lat = String(format:"%f",[coordinate!.latitude])
            long = String(format:"%f",[coordinate!.longitude])
        }
    }
    
    func dictionary() -> Dictionary<String,AnyObject> {
        var dictionary = Dictionary<String,AnyObject>()
        if lat != nil {
            dictionary["lat"] = lat!
        }
        if long != nil {
            dictionary["long"] = long!
        }
        if country != nil {
            dictionary["country"] = country!
        }
        if region != nil {
            dictionary["region"] = region!
        }
        return dictionary
    }
    
    public init(_region: String?, _country: String?, _coordinate: CLLocationCoordinate2D?) {
        region = _region
        country = _country
        coordinate = _coordinate
    }
    
    public convenience override init() {
        self.init(_region: nil, _country: nil, _coordinate: nil)
    }
}

public class gStackSuspension: NSObject {
    public var date: NSDate?
    public var reason: gStackSuspensionReason?
    public var status: Bool?
    public var auth: String?
}

public class gStackSuspensionReason: NSObject {
    public var out: String?
    public var verbose: String?
}

public class triviaUserTournament: NSObject {
    public var date: NSDate?
    public var image: String?
    public var name: String?
    public var prize: String?
    var uuid: String?
}

public class gStackLifelines: NSObject {
    public var half_half: NSNumber?
    public var extra_life: NSNumber?
    public var extra_time: NSNumber?
    public var question_swap: NSNumber?
    public var cash_out: NSNumber?
    public var life: NSNumber?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        half_half = dictionary["half_half"] as? NSNumber
        extra_life = dictionary["extra_life"] as? NSNumber
        extra_time = dictionary["extra_time"] as? NSNumber
        question_swap = dictionary["question_swap"] as? NSNumber
        cash_out = dictionary["cash_out"] as? NSNumber
        life = dictionary["life"] as? NSNumber
    }
}

public class gStackPushSettings: NSObject {
    public var tourney: Bool?
    public var friend: Bool?
    public var inbox: Bool?
    
    func dictionary() -> Dictionary<String,AnyObject> {
        var dictionary = ["tourney":true,"friend":true,"inbox":true]
        if tourney != nil {
            dictionary["tourney"] = tourney!
        }
        if friend != nil {
            dictionary["friend"] = friend!
        }
        if inbox != nil {
            dictionary["inbox"] = inbox!
        }
        return dictionary
    }
    
    public init(_tourney: Bool?, _friend: Bool?, _inbox: Bool?) {
        super.init()
        tourney = _tourney
        friend = _friend
        inbox = _inbox
    }
}

public class gStackCategory: NSObject {
    public var category: String?
    public var _zone: String?
    public var firstPlayed: NSDate?
    public var lastActivity: NSDate?
    public var rating: NSNumber?
    public var level: NSNumber?
    public var gamesPlayed: NSNumber?
    public var gamesWon: NSNumber?
    public var winStreak: NSNumber?
    public var lossStreak: NSNumber?
    public var singleTokens: NSNumber?
    public var versusTokens: NSNumber?
}

public class triviaFriend: NSObject {
    var channel: String?
    public var displayName: String?
    public var facebookName: String?
    public var avatar:String?
    
    // dynamic variable for Friends display
    public var isOnline: Bool{
        return triviaNotificationHandler.sharedInstance.isFriendOnline(self)
    }
    
//    deinit{
//        if let _channel = channel {
//            triviaNotificationHandler.sharedInstance.unsubscribeToPusherChannel(_channel)
//        }
//    }
    init(dictionary: Dictionary<String,AnyObject>) {
        channel = dictionary["channel"] as? String
        displayName = dictionary["displayName"] as? String
        facebookName = dictionary["facebookName"] as? String
        avatar = dictionary["avatar"] as? String
        
        if let _channel = channel {
            triviaNotificationHandler.sharedInstance.subscribeToPushPresentChannel(_channel)
        }
    }
    
    
}

public class triviaUserAddress: NSObject {
    public var line1: String?
    public var line2: String?
    public var city: String?
    public var zipCode: String?
    public var territory: String?
    public var country: String?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        line1 = dictionary["line1"] as? String
        line2 = dictionary["line2"] as? String
        city = dictionary["city"] as? String
        zipCode = dictionary["zipCode"] as? String
        territory = dictionary["territory"] as? String
        country = dictionary["country"] as? String
    }
    
    public init(_line1: String?, _line2: String?, _city: String?, _zipCode: String?, _territory: String?, _country: String?) {
        line1 = _line1
        line2 = _line2
        city = _city
        zipCode = _zipCode
        territory = _territory
        country = _country
    }
}

public class gStackScratcher: NSObject {
    public var prizeImage: String?
    public var prizeDescription: String?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        prizeImage = dictionary["prizeImage"] as? String
        prizeDescription = dictionary["prizeDescription"] as? String
    }
}

