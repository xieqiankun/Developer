//
//  LeaderboardImageViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/6/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

let kMainScreenLeaderboardFillColor = UIColor(red: 212/255, green: 219/255, blue: 33/255, alpha: 1)
let kMainScreenLeaderboardStrokeColor = UIColor(red: 46/255, green: 49/255, blue: 141/255, alpha: 1)


class LeaderboardImageViewController: UIViewController {

    
    var leaderboard: gStackTournamentLeaderboard? {
        didSet{
            dispatch_async(dispatch_get_main_queue()) { 
                self.setLeaders()
            }
        }
    }
    
    var currentTournament: gStackTournament? {
        didSet{
            leaderboard = nil
            gStackFetchLeaderboardForTournament(currentTournament!) { (error, leaderboard) in
                self.leaderboard = leaderboard
                print("set leaderboard")
            }
        }
    }
    // no leader
    @IBOutlet weak var figure: UIImageView!
    
    // 1st
    @IBOutlet weak var view_1: UIView!
    @IBOutlet weak var avatarBackground_1: UIView!
    @IBOutlet weak var avatar_1: UIImageView!
    @IBOutlet weak var displayName_1: UILabel!
    @IBOutlet weak var score_1: UILabel!
    @IBOutlet weak var award_1: UIImageView!
    
    // 2nd
    @IBOutlet weak var view_2: UIView!
    @IBOutlet weak var avatarBackground_2: UIView!
    @IBOutlet weak var avatar_2: UIImageView!
    @IBOutlet weak var displayName_2: UILabel!
    @IBOutlet weak var score_2: UILabel!
    @IBOutlet weak var award_2: UIImageView!
    
    // 3rd
    @IBOutlet weak var view_3: UIView!
    @IBOutlet weak var avatarBackground_3: UIView!
    @IBOutlet weak var avatar_3: UIImageView!
    @IBOutlet weak var displayName_3: UILabel!
    @IBOutlet weak var score_3: UILabel!
    @IBOutlet weak var award_3: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        // Add Notification Center
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LeaderboardImageViewController.updateTournamentLeaderboard(_:)), name: TournamentDidSelectNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LeaderboardImageViewController.updateTournamentLeaderboard(_:)), name: TournamentWillAppearNotificationName, object: nil)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(LeaderboardImageViewController.showDetailLeaderboard))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
        
        leaderboard = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.avatarBackground_1.layer.borderWidth = 4
        self.avatarBackground_1.layer.borderColor = kProfileCellBackgroundColor.CGColor
        self.avatarBackground_1.layer.cornerRadius = self.avatarBackground_1.frame.size.height/2
        self.avatarBackground_1.layer.masksToBounds = true
        
        self.avatarBackground_2.layer.borderWidth = 4
        self.avatarBackground_2.layer.borderColor = kProfileCellBackgroundColor.CGColor
        self.avatarBackground_2.layer.cornerRadius = self.avatarBackground_2.frame.size.height/2
        self.avatarBackground_2.layer.masksToBounds = true
        
        self.avatarBackground_3.layer.borderWidth = 4
        self.avatarBackground_3.layer.borderColor = kProfileCellBackgroundColor.CGColor
        self.avatarBackground_3.layer.cornerRadius = self.avatarBackground_3.frame.size.height/2
        self.avatarBackground_3.layer.masksToBounds = true
    }
    
    func setLeaders() {
        
        if leaderboard == nil {
            UIView.animateWithDuration(0.1, delay: 0, options: [], animations: {
                self.view_1.alpha = 0
                self.view_2.alpha = 0
                self.view_3.alpha = 0
                self.figure.alpha = 0
                }, completion: nil)
            
            return
        }
        
        let num = leaderboard!.leaders.count
        print(num)
        switch num {
        case 0:
            self.figure.alpha = 0
            UIView.animateWithDuration(0.1, delay: 0, options: [], animations: {
                self.figure.alpha = 1
                }, completion: nil)
        case 1:
            self.figure.alpha = 0
            setLeaderInfo(1)
            UIView.animateWithDuration(0.1, delay: 0, options: [], animations: {
                self.view_1.alpha = 1
                self.view_2.alpha = 0
                self.view_3.alpha = 0
                }, completion: nil)

        case 2:
            self.figure.alpha = 0
            setLeaderInfo(1)
            setLeaderInfo(2)
            UIView.animateWithDuration(0.08, delay: 0, options: [], animations: {
                self.view_1.alpha = 1
                }, completion: nil)
            UIView.animateWithDuration(0.08, delay: 0.04, options: [], animations: {
                self.view_2.alpha = 1
                }, completion: nil)

        default:
            self.figure.alpha = 0
            setLeaderInfo(1)
            setLeaderInfo(2)
            setLeaderInfo(3)
            UIView.animateWithDuration(0.08, delay: 0, options: [], animations: {
                self.view_1.alpha = 1
                }, completion: nil)
            UIView.animateWithDuration(0.08, delay: 0.04, options: [], animations: {
                self.view_2.alpha = 1
                }, completion: nil)
            UIView.animateWithDuration(0.08, delay: 0.08, options: [], animations: {
                self.view_3.alpha = 1
                }, completion: nil)
        }
        
    }
    
    func setLeaderInfo(num: Int) {
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : kMainScreenLeaderboardStrokeColor,
            NSForegroundColorAttributeName : kMainScreenLeaderboardFillColor,
            NSStrokeWidthAttributeName : -2.0
        ]
        switch num {
        case 1:
            let name = leaderboard?.leaders[0].displayName
            let score = String((leaderboard?.leaders[0].correctTime!.doubleValue)!)
            displayName_1.attributedText = NSAttributedString(string: name!, attributes: strokeTextAttributes)
            score_1.attributedText = NSAttributedString(string: score, attributes: strokeTextAttributes)
        case 2:
            let name = leaderboard?.leaders[1].displayName
            let score = String((leaderboard?.leaders[1].correctTime!.doubleValue)!)
            displayName_2.attributedText = NSAttributedString(string: name!, attributes: strokeTextAttributes)
            score_2.attributedText = NSAttributedString(string: score, attributes: strokeTextAttributes)
        case 3:
            let name = leaderboard?.leaders[2].displayName
            let score = String((leaderboard?.leaders[2].correctTime!.doubleValue)!)
            displayName_3.attributedText = NSAttributedString(string: name!, attributes: strokeTextAttributes)
            score_3.attributedText = NSAttributedString(string: score, attributes: strokeTextAttributes)
        default:
            break
        }
        
        
        
        
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
