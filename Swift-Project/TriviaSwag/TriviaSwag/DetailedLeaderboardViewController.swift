//
//  DetailedLeaderboardViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/27/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class DetailedLeaderboardViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    var leaderboard:gStackTournamentLeaderboard!
    var currentTournament: gStackTournament!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
        if triviaCurrentUserInbox == nil {
            triviaGetCurrentUserInbox({ (error, inbox) in
                
            })
        }
        if leaderboard == nil {
            gStackFetchLeaderboardForTournament(currentTournament, completion: { [weak self](error, leaderboard) in
                if let strongSelf = self {
                    
                    strongSelf.leaderboard = leaderboard
                    dispatch_async(dispatch_get_main_queue(), { 
                        strongSelf.tableView.reloadData()
                    })
                }
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close() {

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

}


// Custom Transitioning Delegate
extension DetailedLeaderboardViewController: UIViewControllerTransitioningDelegate {
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


extension DetailedLeaderboardViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if let leads = self.leaderboard {
            return leads.leaders.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LeaderboardCell", forIndexPath: indexPath) as! LeaderboardTableViewCell
        
        let leader = self.leaderboard!.leaders[indexPath.section]
     
        let dictionary: [LeaderboardLabels: String] = [LeaderboardLabels.nameLabel: leader.displayName!,
                          LeaderboardLabels.timeLabel: String(leader.correctTime!.doubleValue),
                          LeaderboardLabels.rankLabel: String(indexPath.section + 1)+"."]
        
        cell.setupLabels(dictionary)
        cell.setNeedsLayout()
        return cell
    }
    
    
}

extension DetailedLeaderboardViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let height = tableView.frame.height * 0.18
        return CGFloat(height)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height = tableView.frame.height * 0.012
        return CGFloat(height)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let board = leaderboard {
           let leader = board.leaders[indexPath.section]
            let sb = UIStoryboard(name: "Profile", bundle: nil)
            let vc = sb.instantiateInitialViewController() as! ProfileViewController
            vc.userName = leader.displayName!
            presentViewController(vc, animated: true, completion: nil)
        }
    }

    
}














