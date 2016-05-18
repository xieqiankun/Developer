//
//  ChatViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/16/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,UITextViewDelegate {

    var friend:String!
    
    var chatManager: ChatScreenManager!
    
    var chatMessages = [triviaMessage]()
    
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightconstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textview: UITextView!
    
    @IBOutlet weak var tableview: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    let DATASTEP = 10
    var currentMessageNum = 0
    
    
    
    deinit{
        print("deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textview.layer.cornerRadius = 4
        textview.layer.borderColor = UIColor.blackColor().CGColor
        textview.layer.borderWidth = 2.0

        // congfigure the tableview
        tableview.estimatedRowHeight = 80
        tableview.rowHeight = UITableViewAutomaticDimension
        
        // set data source manager
        chatManager = ChatScreenManager(displayName: friend)
        chatMessages = chatManager.messages
        chatManager.delegate = self
        
        //Refresh control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ChatViewController.getMoreChatMessage), forControlEvents: .ValueChanged)
        tableview.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ChatViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ChatViewController.keyboardWillDisappear(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        scrollToLastRow()

    }
    
    // for refresh control
    func getMoreChatMessage(){
        
        var indexpath = NSIndexPath(forRow: 0, inSection: 0)
        
        if currentMessageNum + 10 < chatMessages.count {
            indexpath = NSIndexPath(forRow: 9, inSection: 0)
            currentMessageNum = currentMessageNum + 10
        } else {
            indexpath = NSIndexPath(forRow: chatMessages.count - currentMessageNum, inSection: 0)
            currentMessageNum = chatMessages.count
        }

        tableview.reloadData()
        tableview.scrollToRowAtIndexPath(indexpath, atScrollPosition: .Top, animated: false)
        refreshControl.endRefreshing()


    }
    
    // Disappear and appear the kb
    func keyboardWillAppear(aNotification: NSNotification) {
        
        let info:NSDictionary = aNotification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight: CGFloat = keyboardSize.height
        
        constraint.constant = keyboardHeight - 20

        UIView.animateWithDuration(0.2) {

            self.view.layoutIfNeeded()
        }

    }
    
    func keyboardWillDisappear(aNotification: NSNotification) {
        
        constraint.constant = 0
        UIView.animateWithDuration(0.2) {
            self.view.layoutIfNeeded()
        }
    }

    
    // helper function
    func scrollToLastRow() {
        print("I am here")
        if chatMessages.count > 0 {
            print("I am here....")

            let indexPath = NSIndexPath(forRow: chatMessages.count - 1, inSection: 0)
            
            let cellRect = tableview.rectForRowAtIndexPath(indexPath)
            let completelyVisible = tableview.bounds.contains(cellRect)
            print(cellRect)
            print(tableview.bounds)
            if !completelyVisible || cellRect.width == 0 && cellRect.height == 0{
                print("I am here.....")

                tableview.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
            }
            
        }
    }
    
    // MARK:- Textview delegate
    func textViewDidChange(textView: UITextView) {
        
        let fixedWidth: CGFloat = textView.frame.size.width
        let newSize: CGSize = textView.sizeThatFits(CGSizeMake(fixedWidth, CGFloat.max))
        
        heightconstraint.constant = newSize.height
        self.view.layoutIfNeeded()
        
        
    }
    
    
    @IBAction func sendMessage() {
        
        let message = triviaMessage(recipientName: friend, message: textview.text!)
        triviaSendMessage(message) { (error, updatedInbox) in
            
        }
    }
    
    @IBAction func close() {
        dismissViewControllerAnimated(true) { 
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK:- UITable Datasource
extension ChatViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //TODO:- Change later when finish core data
        return chatMessages.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = self.chatMessages[indexPath.row]
        
        if item.sender == friend {
            let cell = tableView.dequeueReusableCellWithIdentifier("FriendMessage", forIndexPath: indexPath) as! FriendMessageTableViewCell
            cell.messageBody.text = item.body!
            cell.configueCell()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("MyMessage", forIndexPath: indexPath) as! MyMessageTableViewCell
            cell.messageBody.text = item.body!
            return cell
        }

    }
    
    
}

// MARK:- UITable Delegator
extension ChatViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let friendCell = cell as? FriendMessageTableViewCell {
            friendCell.configueCell()
        }
    }
    
}

extension ChatViewController: ChatScreenManagerDelegate{
    func updata() {
        self.chatMessages = chatManager.messages
        dispatch_async(dispatch_get_main_queue()) { 
            self.tableview.reloadData()
            self.scrollToLastRow()

        }
    }
}









