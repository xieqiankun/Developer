//
//  FriendScreenManager.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/14/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

protocol FriendsListDelegate: class {
    func update()
}

class FriendsScreenManager: NSObject {
    
    static var sharedManager = FriendsScreenManager()
    
    // post update table info
    weak var listDelegate: FriendsListDelegate?
    
    // out going data
    var list:[ListMessageBean]{
        NSLog("prepare data")
        var res = [ListMessageBean]()
        
        for friend in onlineFriend{
            res.append(ListMessageBean(friend: friend))
        }
        for friend in offlineFriend{
            res.append(ListMessageBean(friend: friend))
        }
        
        NSLog("finish prepare data")
        return res
    }
    
    enum MessageType {
        case FriendRequest, FriendMessage, StrangerMessage
    }

    private var friends:[triviaFriend]{
        get {
            if let temp = triviaCurrentUser?.friends{
                return temp
            }
            return [triviaFriend]()
        }
    }
    
    private var onlineFriend  = [triviaFriend]()
    private var offlineFriend = [triviaFriend]()
    
    override init() {
        super.init()
        NSLog("init")
        
        configureList()
        
        // subscirbe to the notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FriendsScreenManager.friendOnline(_:)), name: triviaUserFriendOnlineNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FriendsScreenManager.friendOffline(_:)), name: triviaUserFriendOfflineNotificationName, object: nil)
        NSLog("init end")
        
    }
    
    func configureList() {
    
        //sort online/offline friend
        for friend in friends{
            if friend.isOnline {
                onlineFriend.append(friend)
            } else {
                offlineFriend.append(friend)
            }
        }
        
        
        
        sortAll()
        
    }
    
    func sortAll(){
        onlineFriend.sortInPlace({ (friend1, friend2) -> Bool in
            return friend1.displayName!.localizedStandardCompare(friend2.displayName!) == .OrderedAscending
        })
        offlineFriend.sortInPlace({ (friend1, friend2) -> Bool in
            return friend1.displayName!.localizedStandardCompare(friend2.displayName!) == .OrderedAscending
        })
    
    }
    
    func friendOnline(notification: NSNotification) {
        if let message = notification.userInfo as? [String: String]{
            let displayName = message["displayName"]
            var friend:triviaFriend?
            for ofriend in offlineFriend{
                if ofriend.displayName! == displayName{
                    friend = ofriend
                }
            }
            
            if friend != nil {
                onlineFriend.append(friend!)
                let index = offlineFriend.indexOf(friend!)
                offlineFriend.removeAtIndex(index!)
                onlineFriend.sortInPlace({ (friend1, friend2) -> Bool in
                    return friend1.displayName!.localizedStandardCompare(friend2.displayName!) == .OrderedAscending
                })
            }
            listDelegate?.update()
        }
    }
    
    func friendOffline(notification: NSNotification) {
        if let message = notification.userInfo as? [String: String]{
            let displayName = message["displayName"]
            var friend:triviaFriend?
            for ofriend in onlineFriend{
                if ofriend.displayName! == displayName{
                    friend = ofriend
                }
            }
            
            if friend != nil {
                offlineFriend.append(friend!)
                let index = onlineFriend.indexOf(friend!)
                onlineFriend.removeAtIndex(index!)
                offlineFriend.sortInPlace({ (friend1, friend2) -> Bool in
                    return friend1.displayName!.localizedStandardCompare(friend2.displayName!) == .OrderedAscending
                })
            }
            listDelegate?.update()

        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
}


// data wraper
class ListMessageBean {
    
    var displayName: String?
    var isOnline: Bool = false
    var messageTyep: FriendsScreenManager.MessageType
    
    init(friend: triviaFriend){
        displayName = friend.displayName
        isOnline = friend.isOnline
        messageTyep = FriendsScreenManager.MessageType.FriendMessage
    }
    
}











