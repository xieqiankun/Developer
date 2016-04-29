//
//  LeaderboardImageViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/6/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class LeaderboardImageViewController: UIViewController {

    
    var leaderboard: gStackTournamentLeaderboard?
    
    var currentTournament: gStackTournament? {
        didSet{
            gStackFetchLeaderboardForTournament(currentTournament!) { (error, leaderboard) in
                self.leaderboard = leaderboard
                print(leaderboard?.leaders)
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        // Add Notification Center
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LeaderboardImageViewController.updateTournamentLeaderboard(_:)), name: TournamentDidSelectNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LeaderboardImageViewController.updateTournamentLeaderboard(_:)), name: TournamentWillAppearNotificationName, object: nil)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(LeaderboardImageViewController.showDetailLeaderboard))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    
    }
    
    func showDetailLeaderboard() {
        
        performSegueWithIdentifier("DetailLeaderboard", sender: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func updateTournamentLeaderboard(notification: NSNotification){
        
        if let info = notification.userInfo {
            let temp = info["currentTournament"] as! gStackTournament
            self.currentTournament = temp
        }
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let des = segue.destinationViewController as? DetailedLeaderboardViewController where segue.identifier == "DetailLeaderboard" {
            print("I am here")
            if let lb = self.leaderboard{
                des.leaderboard = lb
            } else {
                des.leaderboard = gStackTournamentLeaderboard(array: [[String:AnyObject]]())
            }
            
        }
        
    }
    

}
