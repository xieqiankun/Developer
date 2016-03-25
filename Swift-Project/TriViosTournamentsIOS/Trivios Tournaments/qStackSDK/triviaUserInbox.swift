//
//  triviaUserInbox.swift
//  gStackSDK
//
//  Created by Evan Bernstein on 8/18/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

public class triviaUserInbox: NSObject {
    public var threads = Dictionary<String,Array<gStackMessage>>()
    public var numUnread: NSNumber?
    public var friendRequests = Array<gStackFriendRequest>()
    public var pendingFriendRequests = Array<gStackFriendRequest>()
    public var incomingAsyncChallenges = Array<gStackAsyncChallengeMessage>()
    public var outgoingAsyncChallenges = Array<gStackAsyncChallengeMessage>()
    public var finishedAsyncChallenges = Array<gStackFinishedChallengeMessage>()
    
    init(dictionary: Dictionary<String,AnyObject>) {
        numUnread = dictionary["numUnread"] as? NSNumber
        if let _friendRequests = dictionary["friendRequests"] as? Array<Dictionary<String,AnyObject>> {
            var gStackFriendRequests = Array<gStackFriendRequest>()
            for friendRequest in _friendRequests {
                let request = gStackFriendRequest(dictionary: friendRequest)
                request.type = "friendrequest"
                gStackFriendRequests.append(request)
            }
            friendRequests = gStackFriendRequests
        }
        if let _pendingFriendRequests = dictionary["pendingFRs"] as? Array<Dictionary<String,AnyObject>> {
            var gStackPendingFriendRequests = Array<gStackFriendRequest>()
            for pendingFriendRequest in _pendingFriendRequests {
                let pendingRequest = gStackFriendRequest(dictionary: pendingFriendRequest)
                pendingRequest.type = "pendingFR"
                gStackPendingFriendRequests.append(pendingRequest)
            }
            pendingFriendRequests = gStackPendingFriendRequests
        }
        if let incomingAsyncDicts = dictionary["incomingAsyncChallenges"] as? Array<Dictionary<String,AnyObject>> {
            var gStackIncomingAsyncs = Array<gStackAsyncChallengeMessage>()
            for incomingAsyncDict in incomingAsyncDicts {
                let incomingAsync = gStackAsyncChallengeMessage(dictionary: incomingAsyncDict)
                incomingAsync.type = "incomingAsyncChallenge"
                gStackIncomingAsyncs.append(incomingAsync)
            }
            incomingAsyncChallenges = gStackIncomingAsyncs
        }
        if let outgoingAsyncDicts = dictionary["outgoingAsyncChallenges"] as? Array<Dictionary<String,AnyObject>> {
            var gStackOutgoingAsyncs = Array<gStackAsyncChallengeMessage>()
            for outgoingAsyncDict in outgoingAsyncDicts {
                let outgoingAsync = gStackAsyncChallengeMessage(dictionary: outgoingAsyncDict)
                outgoingAsync.type = "outgoingAsyncChallenge"
                gStackOutgoingAsyncs.append(outgoingAsync)
            }
            outgoingAsyncChallenges = gStackOutgoingAsyncs
        }
        if let finishedAsyncDicts = dictionary["finishedAsyncChallenges"] as? Array<Dictionary<String,AnyObject>> {
            var gStackFinishedAsyncs = Array<gStackFinishedChallengeMessage>()
            for finishedAsyncDict in finishedAsyncDicts {
                let finishedAsync = gStackFinishedChallengeMessage(dictionary: finishedAsyncDict)
                finishedAsync.type = "finishedAsyncChallenge"
                gStackFinishedAsyncs.append(finishedAsync)
            }
            finishedAsyncChallenges = gStackFinishedAsyncs
        }
        if let incoming = dictionary["incoming"] as? Array<Dictionary<String,AnyObject>> {
            var allMessages = Array<gStackMessage>()
            for message in incoming {
                let incomingMessage = gStackMessage(dictionary: message)
                incomingMessage.type = "incoming"
                allMessages.append(incomingMessage)
            }
            if let outgoing = dictionary["outgoing"] as? Array<Dictionary<String,AnyObject>> {
                for message in outgoing {
                    let outgoingMessage = gStackMessage(dictionary: message)
                    outgoingMessage.type = "outgoing"
                    allMessages.append(outgoingMessage)
                }
            }
            threads = Dictionary<String,Array<gStackMessage>>()
            for message in allMessages {
                var name = message.sender
                if message.recipient != nil && message.recipient! != triviaCurrentUser!.displayName {
                    name = message.recipient
                }
                var thread = threads[name!]
                if thread == nil {
                    thread = Array<gStackMessage>()
                }
                thread!.append(message)
                threads[name!] = thread
            }
        }
    }
    
    public func messageSendersByDate() -> Array<String> {
        let senders = threads.keys
        let sortedSenders = senders.sort({
            (sender1: String, sender2: String) -> Bool in
            let date1 = gStackMessage.latestDateForMessagesInArray(self.threads[sender1]!)
            let date2 = gStackMessage.latestDateForMessagesInArray(self.threads[sender2]!)
            return date1.compare(date2) == NSComparisonResult.OrderedDescending
        })
        return sortedSenders
    }
}


public class gStackCommunique: NSObject {
    var _id: String?
    var type: String?
    public var sender: String?
    public var recipient: String?
    public var date: NSDate?
    
    init(dictionary: Dictionary<String,AnyObject>) {
        sender = dictionary["sender"] as? String
        recipient = dictionary["recipient"] as? String
        if let dateString = dictionary["date"] as? String {
            date = dateForString(dateString)
        }
        _id = dictionary["_id"] as? String
    }
}

public class gStackMessage: gStackCommunique {
    public var dateRead: NSDate?
    public var body: String?
    public var bodyHTML: String?
    public var isRead: Bool?
    var tournamentId: String? //***Make tournament property or function
    public var isPopup: Bool?
    public var popupHeader: String?
    
    override init(dictionary: Dictionary<String,AnyObject>) {
        super.init(dictionary: dictionary)
        if let dateReadString = dictionary["dateRead"] as? String {
            dateRead = dateForString(dateReadString)
        }
        body = dictionary["body"] as? String
        bodyHTML = dictionary["bodyHTML"] as? String
        isRead = dictionary["isRead"] as? Bool
        tournamentId = dictionary["tournamentId"] as? String
        isPopup = dictionary["isPopup"] as? Bool
        popupHeader = dictionary["popupHeader"] as? String
    }
    
    public convenience init(recipientName: String, message: String) {
        self.init(dictionary: Dictionary<String,AnyObject>())
        recipient = recipientName
        body = message
    }
    
    public class func latestMessageInArray(messages: Array<gStackMessage>) -> gStackMessage? {
        var latestDate = NSDate(timeIntervalSince1970: 0)
        var latestMessage: gStackMessage?
        for message in messages {
            if let date = message.date {
                if date.compare(latestDate) == NSComparisonResult.OrderedDescending {
                    latestDate = date
                    latestMessage = message
                }
            }
        }
        return latestMessage
    }
    
    public class func latestDateForMessagesInArray(messages: Array<gStackMessage>) -> NSDate {
        var latestDate = NSDate(timeIntervalSince1970: 0)
        for message in messages {
            if let date = message.date {
                if date.compare(latestDate) == NSComparisonResult.OrderedDescending {
                    latestDate = date
                }
            }
        }
        return latestDate
    }
}

public class gStackFriendRequest: gStackCommunique {
    public var senderAvatar: String?
    public var body: String?
    var token: String?
    
    override init(dictionary: Dictionary<String,AnyObject>) {
        super.init(dictionary: dictionary)
        senderAvatar = dictionary["senderAvatar"] as? String
        body = dictionary["body"] as? String
        token = dictionary["token"] as? String
    }
}

public class gStackAsyncChallengeMessage: gStackCommunique {
    public var challengeId: String?
    public var _zone: String?
    public var category: String?
    public var wager: NSNumber?
//    public var teamNames: Array<String>?
//    public var teamScores: Array<NSNumber>?
//    public var teamAnswersTime: Array<NSNumber>?
//    public var teamAvatars: Array<String>?
    public var isRead: Bool?
    public var isDeclined: Bool?
    
    override init(dictionary: Dictionary<String,AnyObject>) {
        super.init(dictionary: dictionary)
        challengeId = dictionary["challengeId"] as? String
        _zone = dictionary["zone"] as? String
        category = dictionary["category"] as? String
        wager = dictionary["wager"] as? NSNumber
        isRead = dictionary["isRead"] as? Bool
        isDeclined = dictionary["isDeclined"] as? Bool
    }
}

public class gStackFinishedChallengeMessage: gStackCommunique {
    public var challengeId: String?
    public var _zone: String?
    public var category: String?
    public var wager: NSNumber?
    public var winnerTeamNumber: NSNumber?
//    public var teamNames: Array<String>?
//    public var teamScores: Array<NSNumber>?
//    public var teamAnswersTime: Array<NSNumber>?
//    public var teamAvatars: Array<String>?
    public var isRead: Bool?
    
    override init(dictionary: Dictionary<String,AnyObject>) {
        super.init(dictionary: dictionary)
        challengeId = dictionary["challengeId"] as? String
        _zone = dictionary["zone"] as? String
        category = dictionary["category"] as? String
        wager = dictionary["wager"] as? NSNumber
        winnerTeamNumber = dictionary["winnerTeamNum"] as? NSNumber
        isRead = dictionary["isRead"] as? Bool
    }
}