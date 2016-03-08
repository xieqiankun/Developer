//
//  GStackTournament.swift
//  GStack-Swift-SDK
//
//  Created by 谢乾坤 on 3/6/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

public enum GStackTournamentStatus {
    case Expired
    case Active
    case Upcoming
}

public class GStackTournament: NSObject {
    var uuid: String?
    public var name: String?
    public var style:String?
    public var isPrivate: Bool?
    public var buyin: NSNumber?
    public var cap: NSNumber?
    public var startTime: NSDate?
    public var stopTime: NSDate?
    public var questions: GStackTournamentQuestionsInfo?
    public var entries: NSNumber?
    public var maxEntries: NSNumber?
    public var priority: NSNumber?
    public var info: String?
    
    init(tournament: Dictionary<String,AnyObject>) {
        uuid = tournament["uuid"] as? String
        name = tournament["name"] as? String
        style = tournament["style"] as? String
        isPrivate = tournament["isPrivate"] as? Bool

        if let startTimeString = tournament["startTime"] as? String {
            startTime = GStackTournament.dateForString(startTimeString)
        }
        if let stopTimeString = tournament["stopTime"] as? String {
            stopTime = GStackTournament.dateForString(stopTimeString)
        }
        if let questionsDictionary = tournament["questions"] as? Dictionary<String,AnyObject> {
            questions = GStackTournamentQuestionsInfo()
            questions!._zone = questionsDictionary["zone"] as? String
            questions!.category = questionsDictionary["category"] as? String
            questions!.num = questionsDictionary["num"] as? NSNumber
            questions!.time = questionsDictionary["time"] as? NSNumber
        }

    }
    
    class func dateForString(dateString: String) -> NSDate {
        let rfc3339DateFormatter = NSDateFormatter()
        rfc3339DateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        rfc3339DateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        return rfc3339DateFormatter.dateFromString(dateString)!
    }
}

public class GStackTournamentQuestionsInfo: NSObject {
    public var _zone: String?
    public var num: NSNumber?
    public var category: String?
    public var time: NSNumber?
}