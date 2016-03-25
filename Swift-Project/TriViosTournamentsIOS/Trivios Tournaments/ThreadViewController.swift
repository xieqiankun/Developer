//
//  ThreadViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/14/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class ThreadViewController: JSQMessagesViewController, UIGestureRecognizerDelegate {
    
    var messages = Array<gStackMessage>()
    var jsqMessages = Array<JSQMessage>()
    var sender = ""
    var senderAvatarString = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = sender
        
        //Configure JSQMessages        
        inputToolbar!.contentView!.leftBarButtonItem = nil
        
        senderId = triviaCurrentUser?.displayName
        senderDisplayName = triviaCurrentUser?.displayName
        
        sortMessages()
        loadMessagesIntoJSQMessages()
        
        if sender != "Purple Gator" {
            loadSenderProfileData()
        }
        
        
        //Dismiss keyboard on tap
        let tapGR = UITapGestureRecognizer(target: self, action: "collectionViewTapped")
        tapGR.delegate = self
        collectionView!.addGestureRecognizer(tapGR)
        
        
        //Register for notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNewMessage", name: "NewMessageReceived", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.hidden = false
    }
    
    //MARK - UIGestureRecognizer Delegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func collectionViewTapped() {
        if inputToolbar!.contentView!.textView!.isFirstResponder() {
            inputToolbar!.contentView!.textView!.resignFirstResponder()
        }
    }
    
    
    //Do not call this outside of viewDidLoad, because it sorts messages, not jsqMessages
    func sortMessages() {
        messages.sortInPlace({
            (message1: gStackMessage, message2: gStackMessage) -> Bool in
            return message1.date!.compare(message2.date!) == NSComparisonResult.OrderedAscending //Note: messages must have date
        })
    }
    
    //Do not call this outside of viewDidLoad, because messages is likely not up to date
    func loadMessagesIntoJSQMessages() {
        for message in messages {
            loadMessageIntoJSQMessages(message)
        }
    }
    
    func loadMessageIntoJSQMessages(message: gStackMessage) {
        var senderName = senderId
        if let sender = message.sender {
            senderName = sender
        }
        let jsqMessage = JSQMessage(senderId: senderName, senderDisplayName: senderName, date: message.date, text: message.body)
        jsqMessages.append(jsqMessage)
    }
    
    func loadSenderProfileData() {
        gStackFetchProfileForDisplayName(sender, completion: {
            user, error in
            if error != nil {
                print("Error fetching profile: \(error!)")
            } else {
                if let fullAvatarString = user?.avatar {
                    self.senderAvatarString = fullAvatarString.substringFromIndex(fullAvatarString.startIndex.advancedBy(5))
                    //Refresh avatar image... do we need to? Is this the problem?
                }
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    // MARK: - JSQMessagesViewController method overrides
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = gStackMessage(recipientName: sender, message: text)
        gStackSendMessage(message, completion: {
            error, updatedInbox in
            if error != nil {
                print("There was an error sending the message: \(error!)")
            } else {
                let jsqMessage = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
                self.jsqMessages.append(jsqMessage)
                //Note: We are NOT updating messages here, it will get updated ONLY when first initialized via segue
                dispatch_async(dispatch_get_main_queue(), {
                    self.finishSendingMessageAnimated(true)
                })
            }
        })
    }

    override func didPressAccessoryButton(sender: UIButton!) {
        //Do we need to deal with this?
    }
    
    
    // MARK: - JSQMessages CollectionView DataSource
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return jsqMessages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        let message = jsqMessages[indexPath.item]
        if message.senderId == senderId {
            return bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor(red: 70.0/255.0, green: 129.0/255.0, blue: 254/255.0, alpha: 1))
        }
        else {
            return bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        }
    }
    
    //Override here for avatars:
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        var avatarImage = UIImage(named: senderAvatarString)

        let message = jsqMessages[indexPath.item]
        if message.senderId == senderId && isCurrentUserLoggedIn() && triviaCurrentUser!.avatar != nil {
            avatarImage = UIImage(named: triviaCurrentUser!.avatar!)
        }
        return JSQMessagesAvatarImage(avatarImage: avatarImage, highlightedImage: avatarImage, placeholderImage: UIImage(named: "b1.png"))
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = jsqMessages[indexPath.item]
        if indexPath.item == 0 {
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        else {
            let previousMessage = jsqMessages[indexPath.item-1]
            if message.date.minutesAfterDate(previousMessage.date) > 15 {
                return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
            }
        }
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = jsqMessages[indexPath.row]
        
        if message.senderId == senderId {
            return nil
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = jsqMessages[indexPath.item-1]
            if previousMessage.senderId == message.senderId {
                return nil
            }
        }
        
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    
    // MARK: - UICollectionView DataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsqMessages.count
    }
    
    
    // MARK : - Adjusting cell label heights
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = jsqMessages[indexPath.item]
        if indexPath.item == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        else {
            let previousMessage = jsqMessages[indexPath.item-1]
            if message.date.minutesAfterDate(previousMessage.date) > 15 {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
        return 0
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = jsqMessages[indexPath.row]
        
        if message.senderId == senderId {
            return 0
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = jsqMessages[indexPath.item-1]
            if previousMessage.senderId == message.senderId {
                return 0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    
    // MARK: - Responding to collection view tap events
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {
        //Go to profile
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        if sender == "Purple Gator" {
            //Show the full message in another page(?) if it has HTML
        }
    }
    
    
    // MARK: - New Messages
    func receivedNewMessage() {
        gStackGetCurrentUserInbox({
            error, inbox in
            if error != nil {
                print("Error getting user inbox: \(error!)")
            } else {
                if let thread = inbox!.threads[self.sender] where thread.count > self.messages.count {
                    self.messages = thread
                    self.sortMessages()
                    self.loadMessageIntoJSQMessages(self.messages[self.messages.count-1])
                    self.finishReceivingMessageAnimated(true)
                }
            }
        })
    }
}
