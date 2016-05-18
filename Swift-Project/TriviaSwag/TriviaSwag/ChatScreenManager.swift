//
//  ChatScreenManager.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/17/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

protocol ChatScreenManagerDelegate:class {
    func updata()
}

//Provide messages for table
class ChatScreenManager:NSObject {
    
    var messages = [triviaMessage]()
    
    var displayName: String!
    
    weak var delegate: ChatScreenManagerDelegate?
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    init(displayName: String) {
        
        super.init()
        
        self.displayName = displayName
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatScreenManager.refreshMessages), name: triviaFetchInboxNotificationName, object: nil)
        
        if triviaCurrentUserInbox == nil {
            triviaGetCurrentUserInbox({ (error, inbox) in
                
            })
        } else {
            refreshMessages()
        }
        
    }
    
    func refreshMessages() {
        
        if let inbox = triviaCurrentUserInbox {
            if let messages = inbox.threads[self.displayName] {
                self.messages = messages
                self.delegate?.updata()
            }
        }
        
    }
    
    
}