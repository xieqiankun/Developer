//
//  triviaNotificationHandler.swift
//  gStack Client Framework
//
//  Created by Qiankun Xie on 3/24/16.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

var triviaUserFriendOnlineNotificationName = "triviaUserFriendOnline"
var triviaUserFriendOfflineNotificationName = "triviaUserFriendOffline"

class triviaNotificationHandler: NSObject {
    static let sharedInstance = triviaNotificationHandler()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    var pusherClient:PTPusher!
    
    override init() {
        super.init()

        pusherClient = PTPusher(key: "4779f1bf61be1bc819da", delegate: self, encrypted: true)
        pusherClient.authorizationURL = NSURL(string: serverPrefix().stringByAppendingString("pusher/auth"))
        pusherClient.connect()

    }
    
    func subscribeToPushPresentChannel(channel: String ) {
        
        let newNameWithoutPresence = channel.substringFromIndex(channel.startIndex.advancedBy(9))

        pusherClient.subscribeToPresenceChannelNamed(newNameWithoutPresence, delegate: self)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(triviaNotificationHandler.didReceiveEventNotification(_:)), name: PTPusherEventReceivedNotification, object: pusherClient)
    }
    
    func unsubscribeToPusherChannel(channel: String){
        
        let pusherChannel = pusherClient.channelNamed(channel)
        pusherChannel.unsubscribe()
    }
    
    func isFriendOnline(friend:triviaFriend) -> Bool{
        let channel = pusherClient.channelNamed(friend.channel!) as! PTPusherPresenceChannel
        
        let name = channel.members.memberWithID(friend.displayName!)
        if name != nil{
            return true
        }
        return false
    }
    
    
    func didReceiveEventNotification(notificaiton: NSNotification) {
        let event = notificaiton.userInfo![PTPusherEventUserInfoKey] as! PTPusherEvent
        
        print("Pusher Channel:\(event.channel)")
        print("Received event: \(event.name)")
        print("Data: \(event.data)")

        if event.name == "newGameSuccess" {
            let serverIp = event.data["serverIp"] as! String
            let serverPort = (event.data["serverPort"] as! NSNumber).stringValue
            let gameToken = event.data["token"] as! String
            let newConnection = gStackGameConnection(_serverIp: serverIp, _serverPort: serverPort, _gameToken: gameToken)
            
            NSNotificationCenter.defaultCenter().postNotificationName(gStackGameStartedNotificationName, object: nil, userInfo: [gStackConnectionUserInfoKey:newConnection])
        } else if event.name == "newInboxReceived"{
            //Post Notification when receive the message
            NSNotificationCenter.defaultCenter().postNotificationName("NewMessageReceived", object: nil)
        }
    }
    
    
    
}


extension triviaNotificationHandler: PTPusherDelegate, PTPusherPresenceChannelDelegate{
    
    //MARK: - Pusher Delegates
    
    func pusher(pusher: PTPusher!, connectionDidConnect connection: PTPusherConnection!) {
        print("pusher connected")
    }
    
    func pusher(pusher: PTPusher!, didSubscribeToChannel channel: PTPusherChannel!) {
        print("pusher subscribed to channel \(channel.name)")
    }
    
    func presenceChannelDidSubscribe(channel: PTPusherPresenceChannel!) {
        print("subscribed to presence channel \(channel.name)")
    }
    
    func presenceChannel(channel: PTPusherPresenceChannel!, memberAdded member: PTPusherChannelMember!) {
        print("added presence member \(member)")
        NSNotificationCenter.defaultCenter().postNotificationName(triviaUserFriendOnlineNotificationName, object: nil)
    }
    
    func presenceChannel(channel: PTPusherPresenceChannel!, memberRemoved member: PTPusherChannelMember!) {
        print("removed presence member \(member)")
        NSNotificationCenter.defaultCenter().postNotificationName(triviaUserFriendOfflineNotificationName, object: nil)
    }
    
    func pusher(pusher: PTPusher!, willAuthorizeChannel channel: PTPusherChannel!, withRequest request: NSMutableURLRequest!) {
        request.setValue(triviaCurrentUser?._id, forHTTPHeaderField: "_id")
        request.setValue(triviaCurrentUser?.displayName, forHTTPHeaderField: "displayName") //???
        print("pusher will authorize channel \(channel.name)")
    }
    
    func pusher(pusher: PTPusher!, didReceiveErrorEvent errorEvent: PTPusherErrorEvent!) {
        print("pusher received error event \(errorEvent)")
    }
    
    func pusher(pusher: PTPusher!, connection: PTPusherConnection!, failedWithError error: NSError!) {
        print("pusher connection failed with error \(error)")
    }

    
    
    
    
}



