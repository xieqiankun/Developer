//
//  FriendSearchViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/20/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class FriendSearchViewController: UIViewController {

    @IBOutlet weak var searchBarView:UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textfield: UITextField!
    
    var users =  [triviaUser]() {
        didSet{
            filterResult()
            dispatch_async(dispatch_get_main_queue()) { 
                self.tableView.reloadData()
            }
        }
    }
    
    var timer: NSTimer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
        searchBarView.layer.cornerRadius = 15
        searchBarView.layer.borderColor = kMyMessageBorderColor.CGColor
        searchBarView.layer.borderWidth = 3.0

        // verify current user inbox is not nil
        if triviaCurrentUserInbox == nil{
            triviaGetCurrentUserInfo({ (error) in
                
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func performSearch() {
        
        triviaSearchForUsers(textfield.text!) { [weak self](error, users) in
            if error == nil {
                if let fetchedUsers = users {
                    if let strongSelf = self{
                        strongSelf.users = fetchedUsers
                    }
                }
            } else {
                print(error?.domain)
            }
        }
    }
    
    func filterResult() {
        
        for (index, user) in users.enumerate(){
            
            if user.displayName == triviaCurrentUser?.displayName{
                users.removeAtIndex(index)
            }
            
        }
        
    }
    
    @IBAction func close() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func test() {
        
        triviaUnfriend("james") { (error, updatedFriends) in
            
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

// Custom Transitioning Delegate
extension FriendSearchViewController: UIViewControllerTransitioningDelegate {
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


// MARK: - UITextField

extension FriendSearchViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        //print(range.location)
        if range.location > 1 {
            // not making dynamic search too expensive
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(FriendSearchViewController.performSearch), userInfo: nil, repeats: false)
        }
        
        return true
    }
    
    
    
    
}

// MARK:- UITable Datasource
extension FriendSearchViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return users.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendSearchCell", forIndexPath: indexPath) as! FriendSearchTableViewCell
        
        let user = users[indexPath.section]
        
        cell.configureCell(user)
        
        return cell
    }
    
    
}

// MARK:- UITable Delegator
extension FriendSearchViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = tableView.frame.height * 0.2
        return CGFloat(height)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let height = tableView.frame.height * 0.02
        return CGFloat(height)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let sb = UIStoryboard(name: "Profile", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! ProfileViewController
        vc.userName = users[indexPath.section].displayName!
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
}











