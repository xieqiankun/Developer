//
//  gStackNotificationHandler.swift
//  gStack Client Framework
//
//  Created by Qiankun Xie on 3/24/16.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

var gStackGameStartedNotificationName = "gStackGameStarted"
var gStackConnectionUserInfoKey = "Connection"

class gStackNotificationHandler: NSObject, PTPusherDelegate, PTPusherPresenceChannelDelegate {
    static let sharedInstance = gStackNotificationHandler()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    var pusherClient = PTPusher()
    
    func connectToPushServerWithChannel(channel: String) {
        pusherClient = PTPusher(key: "4779f1bf61be1bc819da", delegate: self, encrypted: true)
        //pusherClient = PTPusher.pusherWithKey("4779f1bf61be1bc819da", delegate: self, encrypted: true) as! PTPusher
        //pusherClient.authorizationURL = NSURL(string: serverPrefix().stringByAppendingString("pusher/auth"))
        pusherClient.connect()
        
        pusherClient.subscribeToChannelNamed(channel)
        
        //let newNameWithoutPresence = channel.substringFromIndex(channel.startIndex.advancedBy(9))
        //pusherClient.subscribeToPresenceChannelNamed(newNameWithoutPresence, delegate: self)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(gStackNotificationHandler.didReceiveEventNotification(_:)), name: PTPusherEventReceivedNotification, object: pusherClient)
    }
    
    func connectToPusherServer() {
        if let channel = triviaCurrentUser?.channel {
            connectToPushServerWithChannel(channel)
        } else {
            print("No channel: cannot connect to pusher server !")
        }
    }
    
    func didReceiveEventNotification(notificaiton: NSNotification) {
        let event = notificaiton.userInfo![PTPusherEventUserInfoKey] as! PTPusherEvent
        print("Pusher Channel:\(event.channel)")
        print("Received event: \(event.name)")
        
        if event.name == "newGameSuccess" {
            let serverIp = event.data["serverIp"] as! String
            let serverPort = (event.data["serverPort"] as! NSNumber).stringValue
            let gameToken = event.data["token"] as! String
            let newConnection = gStackGameConnection(_serverIp: serverIp, _serverPort: serverPort, _gameToken: gameToken)
        
            NSNotificationCenter.defaultCenter().postNotificationName(gStackGameStartedNotificationName, object: nil, userInfo: [gStackConnectionUserInfoKey:newConnection])
        }
    }
    
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
    }
    
    func presenceChannel(channel: PTPusherPresenceChannel!, memberRemoved member: PTPusherChannelMember!) {
        print("removed presence member \(member)")
    }
    
    func pusher(pusher: PTPusher!, willAuthorizeChannel channel: PTPusherChannel!, withRequest request: NSMutableURLRequest!) {
        //request.setValue(triviaCurrentUser?._id, forHTTPHeaderField: "_id")
        //request.setValue("haha", forHTTPHeaderField: "displayName") //???
        print("pusher will authorize channel \(channel.name)")
    }
    
    func pusher(pusher: PTPusher!, didReceiveErrorEvent errorEvent: PTPusherErrorEvent!) {
        print("pusher received error event \(errorEvent)")
    }
    
    func pusher(pusher: PTPusher!, connection: PTPusherConnection!, failedWithError error: NSError!) {
        print("pusher connection failed with error \(error)")
    }
}
