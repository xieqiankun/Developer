//
//  triviaTournamentTalk.swift
//  Trivios Tournaments
//
//  Created by 谢乾坤 on 3/25/16.
//  Copyright © 2016 Purple Gator. All rights reserved.
//

import Foundation

public class triviaTournamentChatMessage: NSObject {
    public var messageBody: String?
    public var tournament: gStackTournament?
    var uuid: String?
    public var displayName: String?
    public var avatar: String?
    public var date: NSDate?
    public var votes: NSNumber?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        messageBody = dictionary["message"] as? String
        uuid = dictionary["uuid"] as? String
        displayName = dictionary["displayName"] as? String
        avatar = dictionary["avatar"] as? String
        if let dateString = dictionary["date"] as? String {
            date = dateForString(dateString)
        }
        votes = dictionary["votes"] as? NSNumber
    }
    
    public convenience init(_messageBody: String, _tournament: gStackTournament) {
        self.init(dictionary: Dictionary<String,AnyObject>())
        messageBody = _messageBody
        tournament = _tournament
        displayName = triviaCurrentUser?.displayName
        avatar = triviaCurrentUser?.avatar
        date = NSDate()
        votes = 0
    }
}