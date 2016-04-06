//
//  gStackTournament.swift
//  gStack Client Framework
//
//  Created by Evan Bernstein on 8/17/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

public enum gStackTournamentStatus {
    case Expired
    case Active
    case Upcoming
}

public enum gStackTournamentFilter {
    case None
    case Local
    case Code
}

public protocol gStackTournamentListProtocol: class {
    var tournamentStatus: gStackTournamentStatus { get set }
    var tournamentFilter: gStackTournamentFilter { get set }
    
    func refreshTournaments() -> ()
}

public class gStackTournament: NSObject {
    var uuid: String?
    public var name: String?
    public var isPrivate: Bool?
    public var buyin: NSNumber?
    public var cap: NSNumber?
    public var location: gStackTournamentLocation?
    public var startTime: NSDate?
    public var stopTime: NSDate?
    public var questions: gStackTournamentQuestionsInfo?
    public var prizes: Array<gStackTournamentPrize>?
    public var leader: gStackTournamentLeader?
    public var entries: NSNumber?
    public var maxEntries: NSNumber?
    public var beginnerThreshold: NSNumber?
    public var priority: NSNumber?
    public var info: String?
    
    init(tournament: Dictionary<String,AnyObject>) {
        uuid = tournament["uuid"] as? String
        name = tournament["name"] as? String
        isPrivate = tournament["isPrivate"] as? Bool
        buyin = tournament["buyin"] as? NSNumber
        cap = tournament["cap"] as? NSNumber
        if let _location = tournament["location"] as? Dictionary<String,AnyObject> {
            location = gStackTournamentLocation()
            location!.isLocal = _location["isLocal"] as? Bool
            location!.regions = _location["regions"] as? Array<String>
            location!.latitude = _location["latitude"] as? NSNumber
            location!.longitude = _location["longitude"] as? NSNumber
            location!.countries = _location["countries"] as? Array<String>
            location!.radius = _location["radius"] as? NSNumber
        }
        if let startTimeString = tournament["startTime"] as? String {
            startTime = dateForString(startTimeString)
        }
        if let stopTimeString = tournament["stopTime"] as? String {
            stopTime = dateForString(stopTimeString)
        }
        if let questionsDictionary = tournament["questions"] as? Dictionary<String,AnyObject> {
            questions = gStackTournamentQuestionsInfo()
            questions!._zone = questionsDictionary["zone"] as? String
            questions!.category = questionsDictionary["category"] as? String
            questions!.num = questionsDictionary["num"] as? NSNumber
            questions!.time = questionsDictionary["time"] as? NSNumber
        }
        if let prizesArray = tournament["prizes"] as? Array<Dictionary<String,AnyObject>> {
            prizes = Array<gStackTournamentPrize>()
            for prize in prizesArray {
                let newPrize = gStackTournamentPrize()
                newPrize._id = prize["_id"] as? String
                newPrize.name = prize["name"] as? String
                if let imageDictionary = prize["image"] as? Dictionary<String,AnyObject> {
                    newPrize.image = imageDictionary["image"] as? String
                }
                if let itemDictionary = prize["item"] as? Dictionary<String,AnyObject> {
                    newPrize.itemQuantity = itemDictionary["quantity"] as? NSNumber
                    newPrize.itemType = itemDictionary["type"] as? String
                }
                prizes!.append(newPrize)
            }
        }
        if let leaderDictionary = tournament["leader"] as? Dictionary<String,AnyObject> {
            leader = gStackTournamentLeader(dictionaryFromTournament: leaderDictionary)
        }
        entries = tournament["entries"] as? NSNumber
        maxEntries = tournament["maxEntries"] as? NSNumber
        beginnerThreshold = tournament["beginnerThr"] as? NSNumber
        priority = tournament["priority"] as? NSNumber
        info = tournament["info"] as? String
    }
    
    public class func tournamentsForStatusInArray(status: gStackTournamentStatus, filter: gStackTournamentFilter, array: Array<gStackTournament>) -> Array<gStackTournament> {
        var tournaments = Array<gStackTournament>()
        for tournament in array {
            if status == tournament.status() {
                tournaments.append(tournament)
            }
        }
        
        return tournaments
    }
    
    public func status() -> gStackTournamentStatus {
        let now = NSDate()
        if now.compare(stopTime!) == .OrderedDescending {
            return .Expired
        }
        else if now.compare(startTime!) == .OrderedAscending {
            return .Upcoming
        }
        else {
            return .Active
        }
    }
    
//    public convenience override init() {
//        self.init(tournament: Dictionary<String,AnyObject>())
//    }
    
}

public class gStackTournamentLeaderboard: NSObject {
    public var leaders = Array<gStackTournamentLeader>()
    
    init(array: Array<Dictionary<String,AnyObject>>) {
        for leaderDictionary in array {
            leaders.append(gStackTournamentLeader(dictionaryFromLeaderboard: leaderDictionary))
        }
    }
    
    public convenience init(_leaders: Array<gStackTournamentLeader>) {
        self.init(array: Array<Dictionary<String,AnyObject>>())
        leaders = _leaders
    }
    
    public func indexOfLeader(leader: gStackTournamentLeader) -> Int? {
        return leaders.indexOf(leader)
    }
}

public func ==(left: gStackTournament, right: gStackTournament) -> Bool {
    return left.uuid == right.uuid
}

public func ==(left: gStackTournamentLeader, right: gStackTournamentLeader) -> Bool {
    return left.displayName == right.displayName
}


public class gStackTournamentLocation: NSObject {
    public var isLocal: Bool?
    public var regions: Array<String>?
    public var latitude: NSNumber?
    public var longitude: NSNumber?
    public var countries: Array<String>?
    public var radius: NSNumber?
}

public class gStackTournamentQuestionsInfo: NSObject {
    public var _zone: String?
    public var num: NSNumber?
    public var category: String?
    public var time: NSNumber?
}

public class gStackTournamentPrize: NSObject {
    var _id: String?
    public var name: String?
    public var image: String?
    public var itemQuantity: NSNumber?
    public var itemType: String?
}

public class gStackTournamentLeader: NSObject {
    public var avatar: String?
    public var location: gStackTournamentLeaderLocation?
    public var displayName: String?
    public var correctTime: NSNumber?
    public var correct: NSNumber?
    
    init(dictionaryFromTournament: Dictionary<String,AnyObject>) {
        displayName = dictionaryFromTournament["displayName"] as? String
        avatar = dictionaryFromTournament["avatar"] as? String
        correct = dictionaryFromTournament["correct"] as? NSNumber
        correctTime = dictionaryFromTournament["correctTime"] as? NSNumber
        if let locationDictionary = dictionaryFromTournament["location"] as? Dictionary<String,AnyObject> {
            location = gStackTournamentLeaderLocation()
            location!.region = locationDictionary["region"] as? String
            location!.country = locationDictionary["country"] as? String
        }
    }
    
    init(dictionaryFromLeaderboard: Dictionary<String,AnyObject>) {
        if let teamDictionary = dictionaryFromLeaderboard["team"] as? Dictionary<String,AnyObject> {
            avatar = teamDictionary["avatar"] as? String
            if let teamNames = teamDictionary["teamNames"] as? Array<String> {
                displayName = teamNames.first
            }
            if let locationDictionary = teamDictionary["location"] as? Dictionary<String,AnyObject> {
                location = gStackTournamentLeaderLocation()
                location!.region = locationDictionary["region"] as? String
                location!.country = locationDictionary["country"] as? String
            }
            correctTime = dictionaryFromLeaderboard["correctTime"] as? NSNumber
            correct = dictionaryFromLeaderboard["numCorrect"] as? NSNumber
        }
    }
}

public class gStackTournamentLeaderLocation: NSObject {
    public var region: String?
    public var country: String?
}


public class gStackAsyncChallengeGame: NSObject {
    public var gameMode: gStackAsyncChallengeGameMode?
    public var teams: Array<gStackAsyncChallengeTeam>?
    public var timeEnd: NSDate?
    var uuid: String?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        if let gameModeDictionary = dictionary["gameMode"] as? Dictionary<String,AnyObject> {
            gameMode = gStackAsyncChallengeGameMode(dictionary: gameModeDictionary)
        }
        if let teamsArray = dictionary["teams"] as? Array<Dictionary<String,AnyObject>> {
            teams = Array<gStackAsyncChallengeTeam>()
            for team in teamsArray {
                teams!.append(gStackAsyncChallengeTeam(dictionary: team))
            }
        }
        if let dateString = dictionary["timeEnd"] as? String {
            timeEnd = dateForString(dateString)
        }
        uuid = dictionary["uuid"] as? String
    }
}

public class gStackAsyncChallengeGameMode: NSObject {
    public var type: String?
    public var _zone: String?
    public var category: String?
    public var wager: NSNumber?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        type = dictionary["type"] as? String
        _zone = dictionary["zone"] as? String
        category = dictionary["category"] as? String
        wager = dictionary["wager"] as? NSNumber
    }
}

public class gStackAsyncChallengeTeam: NSObject {
    public var teamNames: Array<String>?
    public var teamAnswers: Array<NSNumber>?
    public var teamScores: Array<NSNumber>?
    public var teamTimes: Array<NSNumber>?
    public var teamAvatars: Array<String>?
    //***Is this all the fields we need?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        teamNames = dictionary["teamNames"] as? Array<String>
        teamAnswers = dictionary["teamAnswers"] as? Array<NSNumber>
        teamScores = dictionary["teamScores"] as? Array<NSNumber>
        teamTimes = dictionary["teamTimes"] as? Array<NSNumber>
        teamAvatars = dictionary["teamAvatars"] as? Array<String>
    }
}