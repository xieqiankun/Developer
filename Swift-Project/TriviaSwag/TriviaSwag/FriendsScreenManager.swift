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
    
    // post update table info
    weak var listDelegate: FriendsListDelegate?
    
    // inbox message quantity
    var newMessages = [String: Int]()
    
    // out going data
    var list:[ListMessageBean]{
        NSLog("prepare data")
        var res = [ListMessageBean]()
        
        // sort messages and send to client
        for friend in messageFriend {
            if let num = newMessages[friend.displayName!]{
                res.append(ListMessageBean(friend: friend, messageNum: num ))
            }
        }
        for friend in onlineFriend{
            res.append(ListMessageBean(friend: friend,messageNum: 0))
        }
        for friend in offlineFriend{
            res.append(ListMessageBean(friend: friend,messageNum: 0))
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
    
    private var messageFriend = [triviaFriend]()
    
    private var onlineFriend  = [triviaFriend]()
    private var offlineFriend = [triviaFriend]()
    
    override init() {
        super.init()
        
        
        if let _ =  triviaCurrentUserInbox {
            setNewMessagesQuantity()
        } else {
            triviaGetCurrentUserInbox({ (error, inbox) in
           
            })
        }
        
        configureList()

        
        // subscirbe to the notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FriendsScreenManager.friendOnline(_:)), name: triviaUserFriendOnlineNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FriendsScreenManager.friendOffline(_:)), name: triviaUserFriendOfflineNotificationName, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FriendsScreenManager.updateUserInbox), name: triviaUpdateInboxNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FriendsScreenManager.updateUserInbox), name: triviaDidDeleteMessageNotificationName, object: nil)
        
    }
    
    func configureList() {
        
        messageFriend.removeAll()
        onlineFriend.removeAll()
        offlineFriend.removeAll()
        
        //sort online/offline friend
        for friend in friends{
            if let _ = newMessages[friend.displayName!]{
                messageFriend.append(friend)
            }else if friend.isOnline {
                onlineFriend.append(friend)
            } else {
                offlineFriend.append(friend)
            }
        }
        
        sortAll()
        
    }
    
    
    
    // sorted by sended date
    func setNewMessagesQuantity() {
        
        if let inbox = triviaCurrentUserInbox {
            self.newMessages.removeAll()
            let threads = inbox.messageSendersByDate()
            for displayName in threads {
                if let messages = inbox.threads[displayName] {
                    newMessages[displayName] = messages.count
                }
            }
        }
        
    }
    
    // sort part
    func sortAll(){
        sortMessageFriends()
        sortOnlineFriends()
        sortOfflineFriends()
    }
    
    func sortMessageFriends() {
        
        let names = Array(newMessages.keys)
        
        messageFriend.sortInPlace { (friend1, friend2) -> Bool in
            
            return names.indexOf(friend1.displayName!) > names.indexOf(friend2.displayName!)
            
        }
        
    }
    
    func sortOnlineFriends() {
        
        onlineFriend.sortInPlace({ (friend1, friend2) -> Bool in

            return friend1.displayName!.localizedStandardCompare(friend2.displayName!) == .OrderedAscending
           
        })
    }
    
    func sortOfflineFriends() {
        
        offlineFriend.sortInPlace({ (friend1, friend2) -> Bool in
            
            return friend1.displayName!.localizedStandardCompare(friend2.displayName!) == .OrderedAscending
            
        })
    }
    
    // notification handler
    func friendOnline(notification: NSNotification) {
        if let message = notification.userInfo as? [String: String]{
            let displayName = message["displayName"]
            var friend:triviaFriend?
            for ofriend in offlineFriend{
                if ofriend.displayName! == displayName{
                    friend = ofriend
                    break
                }
            }
            
            if friend != nil {
                onlineFriend.append(friend!)
                let index = offlineFriend.indexOf(friend!)
                offlineFriend.removeAtIndex(index!)
                sortOnlineFriends()
            } else {
                
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
                    break
                }
            }
            
            if friend != nil {
                offlineFriend.append(friend!)
                let index = onlineFriend.indexOf(friend!)
                onlineFriend.removeAtIndex(index!)
                sortOfflineFriends()
            }
            listDelegate?.update()

        }
    }
    
    func updateUserInbox() {
        
        setNewMessagesQuantity()
        configureList()
        listDelegate?.update()
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
    var newMessageNumber: Int = 0
    
    init(friend: triviaFriend, messageNum: Int){
        displayName = friend.displayName
        isOnline = friend.isOnline
        messageTyep = FriendsScreenManager.MessageType.FriendMessage
        newMessageNumber = messageNum
    }
    
}











