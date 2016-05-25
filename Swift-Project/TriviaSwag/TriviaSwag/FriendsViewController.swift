//
//  FriendsViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/12/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    

    var manager = FriendsScreenManager()//.sharedManager
    
    var selectedIndexpath = NSIndexPath(forRow: 0, inSection: 0)
    
    var list:[ListMessageBean]! {
        didSet{
            dispatch_async(dispatch_get_main_queue()) { 
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        manager.listDelegate = self
        list = manager.list

    }
    

    func refresh() {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func close () {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func shareButtonClicked(sender: UIButton) {
        let textToShare = "Swift is awesome!  Check out this website about it!"
        
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/"),let image : UIImage = UIImage(named: "BlueMan")!
 {
            let objectsToShare = [textToShare, myWebsite, image]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destinationViewController as? ChatViewController where segue.identifier == "Chat" {
            vc.friend = list[selectedIndexpath.section].displayName!
        }
        
        
    }
    

}



// Custom Transitioning Delegate
extension FriendsViewController: UIViewControllerTransitioningDelegate {
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

// MARK:- UITable Datasource
extension FriendsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return list.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = self.list[indexPath.section]
        
        if item.messageType == FriendsScreenManager.MessageType.FriendRequest{
            let cell = tableView.dequeueReusableCellWithIdentifier("RequestCell", forIndexPath: indexPath) as! FriendRequestTableViewCell
            cell.configueCell(item)
            return cell

        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendsTableViewCell
            cell.configueCell(item)
            return cell

        }


        
    }
    
    
}

// MARK:- UITable Delegator
extension FriendsViewController: UITableViewDelegate {
    
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
        
        let item = list[indexPath.section]
        if item.messageType == FriendsScreenManager.MessageType.FriendMessage {
            selectedIndexpath = indexPath
            performSegueWithIdentifier("Chat", sender: self)
        }

    }
    
}

// MARK:- FriendListDelegate
extension FriendsViewController: FriendsListDelegate{
    
    
    func update() {
        self.list = manager.list
    }

    
}












