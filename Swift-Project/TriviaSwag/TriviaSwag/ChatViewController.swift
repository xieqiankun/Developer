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
    
    var chatMessages: [triviaMessageMO]! {
        didSet{
            dispatch_async(dispatch_get_main_queue()) {
                print("Start to reloard table")
                self.tableview.reloadData()
                self.scrollToLastRow()
                
            }
        }
    }
    
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightconstraint: NSLayoutConstraint!
    
    // For send message text
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var textBackground: UIView!
    
    // For table view
    @IBOutlet weak var tableview: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    let DATASTEP = 10
    var currentMessageNum = 0
    var shouldPrescroll = false

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }

    deinit{
        print("deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("========== view did load -----------")
        self.view.backgroundColor = UIColor.clearColor()
        configureTextView()
        
        // set data source manager
        chatManager = ChatScreenManager(displayName: friend)
        chatMessages = chatManager.messages
        chatManager.delegate = self
        
        // congfigure the tableview
        tableview.estimatedRowHeight = 80
        tableview.rowHeight = UITableViewAutomaticDimension
        
        //Refresh control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ChatViewController.getMoreChatMessage), forControlEvents: .ValueChanged)
        tableview.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ChatViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ChatViewController.keyboardWillDisappear(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func configureTextView() {
        
        textBackground.layer.cornerRadius = 15
        textBackground.layer.borderColor = kFriendMessageBorderColor.CGColor
        textBackground.layer.borderWidth = 3.0
    }
    
    override func viewWillAppear(animated: Bool) {
        print(#function)
        shouldPrescroll = true
    }
    override func viewDidAppear(animated: Bool) {
        print(#function)
        shouldPrescroll = false

    }
    override func viewDidLayoutSubviews() {
        print(#function)
        if shouldPrescroll{
            // call at view will appear will not work cause when you scroll down will call layout view again
            scrollToLastRow()
        }

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

        if chatMessages.count > 0 {

            //let indexPath = NSIndexPath(forRow: chatMessages.count - 1, inSection: 0)
            var indexPath = NSIndexPath(forRow: DATASTEP - 1, inSection:  0)
            if chatMessages.count < DATASTEP {
                indexPath = NSIndexPath(forRow: chatMessages.count - 1, inSection: 0)
            }
            
            let cellRect = tableview.rectForRowAtIndexPath(indexPath)
            let completelyVisible = tableview.bounds.contains(cellRect)
            print(cellRect)
            print(tableview.bounds)
            if !completelyVisible || cellRect.width == 0 && cellRect.height == 0{

                tableview.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
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
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textview.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        textview.text = ""
        textview.alpha = 1
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textview.text == "" {
            textview.text = "Reply..."
            textview.alpha = 0.5
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func sendMessage() {
        
        let message = triviaMessage(recipientName: friend, message: textview.text!)
        self.chatManager.sendMessage(message)
        textview.text = ""

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
        if chatMessages.count < DATASTEP {
            return chatMessages.count
        }
        return DATASTEP
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var item: triviaMessageMO
        
        if chatMessages.count < DATASTEP {
            item  = self.chatMessages[indexPath.row]
        } else {
            item = self.chatMessages[chatMessages.count - DATASTEP + indexPath.row]
        }
        
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
        } else if let mycell = cell as? MyMessageTableViewCell {
            mycell.configueCell()
        }
    }
    
}

extension ChatViewController: ChatScreenManagerDelegate{
    func userInboxDidUpdata() {
        self.chatMessages = chatManager.messages

    }
    // may use for spining
    func userDidSendMessage() {
        
    }
}


// Custom Transitioning Delegate
extension ChatViewController: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController( presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        return DimmingPresentationController( presentedViewController: presented, presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController( presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInAnimationController()
    }
    
    func animationControllerForDismissedController( dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeOutAnimationController()
    }
    
}







