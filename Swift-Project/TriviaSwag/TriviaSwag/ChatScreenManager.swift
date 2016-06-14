//
//  ChatScreenManager.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/17/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation
import CoreData

protocol ChatScreenManagerDelegate:class {
    func userInboxDidUpdata()
    func userDidSendMessage()
}

//Provide messages for table
class ChatScreenManager:NSObject {
    
    //var messages = [triviaMessage]()
    
    var displayName: String!
    
    let managedObjectContext = getManagedObjectContext()
    
    weak var delegate: ChatScreenManagerDelegate?
    
    
    
    // CoreData
    
    var messages =  [triviaMessageMO]()
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    init(displayName: String) {
        
        super.init()
        
        self.displayName = displayName
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatScreenManager.refreshMessages), name: triviaUpdateInboxNotificationName, object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatScreenManager.refreshMessages), name: triviaDidSendMessageNotificationName, object: nil)
        
        fetchMessages()
        
        if triviaCurrentUserInbox == nil {
            triviaGetCurrentUserInbox({ (error, inbox) in
                
            })
        } else {
            refreshMessages()
        }
        
    }
    
    
    func fetchMessages() {
        
        let fetchRequest = NSFetchRequest()
        
        let entity = NSEntityDescription.entityForName("Message", inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entity
        let pre1 = NSPredicate(format: "userName == %@", triviaCurrentUser!.displayName!)
        let pre2 = NSPredicate(format: "sender == %@ OR receiver == %@",displayName, displayName)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pre1, pre2])
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            // 4
            let foundObjects = try managedObjectContext.executeFetchRequest(fetchRequest)
            // 5
            messages = foundObjects as! [triviaMessageMO]
            
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    // insert message into database and delete the message in inbox
    func insertNewMessages(messages: [triviaMessage]) {
        
        if messages.count > 0 {
            
            let message =  messages[0]
            let _message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! triviaMessageMO
            _message.receiver = message.recipient
            _message.sender = message.sender
            _message.date = message.date
            _message.body = message.body
            _message.userName = triviaCurrentUser!.displayName!
            self.messages.append(_message)
            // delete messages on server side
            triviaDeleteMessage(message, completion: { (error, updatedInbox) in
                if error == nil {
                    print("\(message._id)")
                }
            })

        }
        
//        for message in messages {
//            
//            let _message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! triviaMessageMO
//            _message.receiver = message.recipient
//            _message.sender = message.sender
//            _message.date = message.date
//            _message.body = message.body
//            _message.userName = triviaCurrentUser!.displayName!
//            self.messages.append(_message)
//            // delete messages on server side
//            triviaDeleteMessage(message, completion: { (error, updatedInbox) in
//                if error == nil {
//                    print("\(message._id)")
//                }
//            })
//        }
        saveContext()
    }
    
    // when update current inbox, will post notification to refresh messages
    func sendMessage(message:triviaMessage) {
        
        triviaSendMessage(message) { (error, updatedInbox) in

        }
    }
    
    // update when update trivia current inbox
    func refreshMessages() {
        
        if let inbox = triviaCurrentUserInbox {
            if let messages = inbox.threads[self.displayName] {
                insertNewMessages(messages)
                self.messages.sortInPlace({ (message1, message2) -> Bool in
                   return  message1.date!.compare(message2.date!) == NSComparisonResult.OrderedAscending
                })
                self.delegate?.userInboxDidUpdata()
            }
        }
        
    }
    
    
}