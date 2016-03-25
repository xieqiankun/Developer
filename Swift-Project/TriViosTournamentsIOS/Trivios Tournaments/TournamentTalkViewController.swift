//
//  TournamentTalkViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/24/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class TournamentTalkTableViewCell: UITableViewCell {
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var upVoteButton: UIButton!
    @IBOutlet var downVoteButton: UIButton!
    @IBOutlet var votesLabel: UILabel!
}

class TournamentTalkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var informationSuperview: UIView!
    @IBOutlet var prizeImageView: UIImageView!
    @IBOutlet var tournamentNameLabel: UILabel!
    @IBOutlet var prizeDescriptionLabel: UILabel!
    @IBOutlet var timeRemainingLabel: UILabel!
    @IBOutlet var repliesAndEntriesLabel: UILabel!
    
    @IBOutlet var chatTableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    @IBOutlet var sendMessageSuperview: UIView!
    @IBOutlet var sendMessageTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    
    @IBOutlet var sendMessageSuperviewBottomLayout: NSLayoutConstraint!
    
    var tournament: gStackTournament?
    var messages = Array<triviaTournamentChatMessage>()
    
    var upVotedMessages = Array<triviaTournamentChatMessage>()
    var downVotedMessages = Array<triviaTournamentChatMessage>()
    
    var modal: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshControl.addTarget(self, action: "refreshMessages", forControlEvents: .ValueChanged)
        chatTableView.addSubview(refreshControl)
        
        displayTournamentInfo()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshMessages()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    func doneButtonPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func displayTournamentInfo() {
        if tournament != nil {
            tournamentNameLabel.text = tournament!.name
            
            if let prize = tournament!.prizes?.first {
                prizeDescriptionLabel.text = prize.name
                
                if let imageString = prize.image {
                    let imageURLString = "http://" + imageString
                    prizeImageView.imageURL = NSURL(string: imageURLString)
                }
            }
            
            timeRemainingLabel.text = stringForTournamentTimeComparedToNow(tournament!)
            
            if let numberOfEntries = tournament?.entries {
                repliesAndEntriesLabel.text = "\(messages.count) Replies | \(numberOfEntries) Entries"
            }
        }
    }

    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath) as! TournamentTalkTableViewCell

        //Configure cell...
        let message = messages[indexPath.row]
        
        if var avatarImageString = message.avatar {
            let index = avatarImageString.startIndex.advancedBy(5)
            avatarImageString = avatarImageString.substringFromIndex(index)
            cell.avatarImageView.image = UIImage(named: avatarImageString)
        }
        
        cell.usernameLabel.text = message.displayName
        
        cell.messageLabel.text = message.messageBody
        
        cell.timeLabel.text = stringForChatMessageTimeComparedToNow(message)
        
        cell.votesLabel.text = message.votes?.stringValue
        
        cell.upVoteButton.tag = indexPath.row
        cell.downVoteButton.tag = indexPath.row
        
        cell.selectionStyle = .None
        
        var found = false
        for _message in upVotedMessages {
            if message == _message {
                found = true
            }
        }
        var found2 = false
        for _message in downVotedMessages {
            if message == _message {
                found2 = true
            }
        }
//        if find(upVotedMessages, message) != nil { //This should really work, though
        if found == true {
            cell.upVoteButton.enabled = false
            cell.downVoteButton.enabled = false
            cell.upVoteButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Disabled)
            cell.downVoteButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        }
//        else if find(downVotedMessages, message) != nil {
        else if found2 == true {
            cell.upVoteButton.enabled = false
            cell.downVoteButton.enabled = false
            cell.downVoteButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Disabled)
            cell.upVoteButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        }
        else {
            cell.upVoteButton.enabled = true
            cell.downVoteButton.enabled = true
        }
        
        return cell
    }
    
    
    //Voting
    @IBAction func upVote(sender: UIButton) {
        let message = messages[sender.tag]
        gStackUpVoteChatMessageInTournament(tournament!, message: message, completion: {
            error, _message in
            if error != nil {
                print("Error upvoting message")
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.messages[sender.tag] = _message!
                    self.chatTableView.reloadData()
                    self.refreshMessages()
                })
            }
        })
    }
    
    @IBAction func downVote(sender: UIButton) {
        let message = messages[sender.tag]
        gStackDownVoteChatMessageInTournament(tournament!, message: message, completion: {
            error, _message in
            if error != nil {
                print("Error downvoting message")
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.messages[sender.tag] = _message!
                    self.chatTableView.reloadData()
                    self.refreshMessages()
                })
            }
        })
    }
    
    
    //Refresh Control
    func refreshMessages() {
        triviaGetChatMessagesForTournament(tournament!, completion: {
            error, _messages in
            if error != nil {
                print("Error getting chat messages")
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.messages = _messages!
                    /*
                    self.messages = sorted(self.messages, {
                        (message1: triviaTournamentChatMessage, message2: triviaTournamentChatMessage) -> Bool in
                        return message1.votes!.integerValue > message2.votes!.integerValue //Sorts by votes-- should we factor in date as well?
                    })
                    */
                    self.chatTableView.reloadData()
                    self.displayTournamentInfo()
                })
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.refreshControl.endRefreshing()
            })
        })
        triviaGetUpVotedChatMessagesInTournament(tournament!, completion: {
            error, messages in
            if error != nil {
                print("Error getting upvoted chat messages")
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    print("Got upvoted messages: \(messages!.count)")
                    self.upVotedMessages = messages!
                    self.chatTableView.reloadData()
                })
            }
        })
        triviaGetDownVotedChatMessagesInTournament(tournament!, completion: {
            error, messages in
            if error != nil {
                print("Error getting downvoted chat messages")
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    print("Got downvoted messages: \(messages!.count)")
                    self.downVotedMessages = messages!
                    self.chatTableView.reloadData()
                })
            }
        })
    }
    
    
    
    //UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        sendMessage()
        
        return true
    }
    
    @IBAction func sendMessage() {
        triviaSendTournamentChatMessage(triviaTournamentChatMessage(_messageBody: sendMessageTextField.text!, _tournament: tournament!), completion: {
            error, message in
            if error != nil {
                print("Error sending message: \(error!)")
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.messages.append(message!)
                    self.chatTableView.reloadData()
                    self.sendMessageTextField.text = ""
                    self.sendMessageTextField.resignFirstResponder()
                    self.chatTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                    self.displayTournamentInfo()
                })
            }
        })
    }
    
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            var constant: CGFloat = -40
            if self.modal == true {
                constant = 0
            }
            self.sendMessageSuperviewBottomLayout.constant = keyboardFrame.size.height + constant
        })
    }
    
    func keyboardWasHidden(notification: NSNotification) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.sendMessageSuperviewBottomLayout.constant = 0
        })
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        if sendMessageTextField.isFirstResponder() && touch!.view != sendMessageTextField {
            dispatch_async(dispatch_get_main_queue(), {
                self.sendMessageTextField.resignFirstResponder()
            })
        }
        
        super.touchesBegan(touches, withEvent: event)
    }
}
