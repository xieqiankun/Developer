//
//  DetailedLeaderboardViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/27/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class DetailedLeaderboardViewController: UIViewController {

    var leaderboard:gStackTournamentLeaderboard!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
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
        return self.leaderboard.leaders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LeaderboardCell", forIndexPath: indexPath)
        
        let leader = self.leaderboard.leaders[indexPath.row]
        
        cell.textLabel?.text = leader.displayName
        
        return cell
    }
    
    
    
    
}

extension DetailedTournamentViewController: UITableViewDelegate {
    
    
    
    
}














