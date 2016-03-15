//
//  PusherSock.swift
//  GStack-Swift-SDK
//
//  Created by 谢乾坤 on 3/4/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class PusherSock:NSObject, PTPusherDelegate, PTPusherPresenceChannelDelegate{
    
    static let sharedPusher = PusherSock()
    
    var pusherClient: PTPusher?
    var pusherChannel: PTPusherChannel?
    var pusherEventBinding: PTPusherEventBinding?
    
    func connectToPushServerWithChannel(channel: String) {
        
        pusherClient = PTPusher.init(key: "4779f1bf61be1bc819da", delegate: self, encrypted: true) as PTPusher

        pusherClient!.connect()
        
        pusherChannel = pusherClient?.subscribeToChannelNamed(channel)
        
        print("I am here in pusher")
    }
    
    func didReceiveEvent(event: String, completion:PTPusherEventBlockHandler){
        
        self.pusherChannel?.removeAllBindings()
        
//        if self.pusherEventBinding != nil{
//            self.pusherClient?.removeBinding(self.pusherEventBinding)
//        }
        self.pusherChannel?.bindToEventNamed(event, handleWithBlock: completion)
        
       // self.pusherEventBinding = self.pusherChannel?.bindToEventNamed(event, handleWithBlock: completion)
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
        //request.setValue(qStackCurrentUser?._id, forHTTPHeaderField: "_id")
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