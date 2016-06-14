//
//  DetailedTournamentViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/5/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class DetailedTournamentViewController: UIViewController {

    var tournament: gStackTournament? {
        didSet {
            hideUI()
            setupTournamentInfo()
            showUI()
        }
    }
    
    @IBOutlet weak var tournamentNameLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var questionNum: UILabel!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var tickets: UILabel!
    
    @IBOutlet weak var awardview: AwardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Notification Center
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailedTournamentViewController.updateTournamentInfo(_:)), name: TournamentDidSelectNotificationName, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailedTournamentViewController.updateTournamentInfo(_:)), name: TournamentWillAppearNotificationName, object: nil)
        
        setCornerEdge()
        // Do any additional setup after loading the view.
    }
    
    deinit{
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        //call here to change the background
        //setBackground("Tournament-Image-Placeholder")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBackground(name:String) {
        
        let width = self.view.bounds.size.width
        let height = self.view.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: name)
        // Change
        imageViewBackground.contentMode = UIViewContentMode.ScaleToFill
        imageViewBackground.alpha = 0.5
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)
        imageViewBackground.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
    }
    
    func setCornerEdge(){
        
        view.layer.borderColor = UIColor.darkGrayColor().CGColor
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2.0
        
    }
    
    
    func setupTournamentInfo() {
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : kMainScreenLeaderboardStrokeColor,
            NSForegroundColorAttributeName : kMainScreenLeaderboardFillColor,
            NSStrokeWidthAttributeName : -2.0
        ]
        
        self.tournamentNameLabel.attributedText = NSAttributedString(string: (tournament?.name!)!, attributes: strokeTextAttributes)
        
        if self.tournament?.status() == gStackTournamentStatus.Active {
            self.startBtn.hidden = false
        } else {
            self.startBtn.hidden = true
        }
        
        if let num = tournament?.questions?.num?.integerValue{
            questionNum.text = "\(num) questions"
        }
        if let num = tournament?.buyin?.integerValue{
            if num == 0 || num == 1 {
                tickets.text = "\(num) ticket"
            } else {
                tickets.text = "\(num) tickets"
            }
        }
        calculateRemainDate()
        
        if let prizes = tournament?.prizes{
            
            for (index, prize) in prizes.enumerate(){
                
                switch index {
                case 0:
                    if let url = prize.image, let nsurl = NSURL(string: url){
                        //task1 = award_1.loadImageWithURL(nsurl)
                        awardview.setImage(nsurl)
                    }
                default:
                    break
                }
            }
        }

    }
    
    func calculateRemainDate() {
        
        let userCalendar = NSCalendar.currentCalendar()

        // here we set the current date
        let nowDate = NSDate()
        let startDate = tournament!.startTime
        let endDate = tournament!.stopTime
        
        let dayCalendarUnit: NSCalendarUnit = [.Day, .Hour, .Minute]
        
        if nowDate.compare(startDate!) == .OrderedAscending {
        // future tournament
            let dayDifference = userCalendar.components(
                dayCalendarUnit,
                fromDate: nowDate,
                toDate: startDate!,
                options: [])
            
            var res = ""
            var hasDay = true
            if dayDifference.day > 1 {
                res = res + "\(dayDifference.day) days "
            } else {
                if dayDifference.day == 0 {
                    hasDay = false
                } else {
                    res = res + "\(dayDifference.day) day "
                }
            }
            if dayDifference.hour > 1 {
                res = res + "\(dayDifference.hour) hours "
            } else {
                res = res + "\(dayDifference.hour) hour "
            }
            if !hasDay {
                if dayDifference.minute > 1{
                    res = res + "\(dayDifference.minute) mins "
                } else {
                    res = res + "\(dayDifference.minute) min "
                }
            }
            
            timeRemaining.text = "starting in " + res

            
        } else if nowDate.compare(endDate!) == .OrderedDescending {
        // past tournament
            let dayDifference = userCalendar.components(
                dayCalendarUnit,
                fromDate: endDate!,
                toDate: nowDate,
                options: [])
            
            if dayDifference.day > 1 {
                timeRemaining.text = "\(dayDifference.day) days ago"
            } else {
                timeRemaining.text = "\(dayDifference.day) day ago"

            }
            
        } else {
            
            let dayDifference = userCalendar.components(
                dayCalendarUnit,
                fromDate: nowDate,
                toDate: endDate!,
                options: [])
            
            var res = ""
            var hasDay = true
            if dayDifference.day > 1 {
                res = res + "\(dayDifference.day) days "
            } else {
                if dayDifference.day == 0 {
                    hasDay = false
                } else {
                    res = res + "\(dayDifference.day) day "
                }
            }
            if dayDifference.hour > 1 {
                res = res + "\(dayDifference.hour) hours "
            } else {
                res = res + "\(dayDifference.hour) hour "
            }
            if !hasDay {
                if dayDifference.minute > 1{
                    res = res + "\(dayDifference.minute) mins "
                } else {
                    res = res + "\(dayDifference.minute) min "
                }
            }
            
            timeRemaining.text = res + "remaining"
            
        }
        
        
        
        
        
    }
    
    func hideUI() {
        
        UIView.animateWithDuration(0.05) {
            
            self.tournamentNameLabel.alpha = 0
            self.questionNum.alpha = 0
            self.tickets.alpha = 0
            self.timeRemaining.alpha = 0
        }
        
    }
    
    func showUI() {
        
        UIView.animateWithDuration(0.1) {
            
            self.tournamentNameLabel.alpha = 1
            self.questionNum.alpha = 1
            self.tickets.alpha = 1
            self.timeRemaining.alpha = 1
        }
        
        
        
    }
    
    
    // Update the UI with new Tournament
    func updateTournamentInfo(notification: NSNotification) {
        
        if let info = notification.userInfo {
            let temp = info["currentTournament"] as! gStackTournament
            self.tournament = temp
            
        }
        
    }
    
    @IBAction func viewTourneyDetails(sender: UIButton) {
        let pvc = parentViewController as! HomeViewController
        if let tourney = tournament{
            pvc.viewTournamentDetails(tourney, sender: sender)
        }
    }

    @IBAction func startToPlayGame(sender: UIButton) {
        
        prepareTStartTheGame()
//        let sb = UIStoryboard(name: "GameOver", bundle: nil)
//        let vc = sb.instantiateInitialViewController() as! GameOverViewController
//        vc.tournament = tournament
//        presentViewController(vc, animated: true, completion: nil)

    }
    
    func prepareTStartTheGame(){
        
        
        if isCurrentUserLoggedIn() {
            self.performSegueWithIdentifier("GamePlaySegue", sender: self)
        } else {
            let button1 = AlertButton(title: "Login", imageNames: [], style: .Normal, action: {
                self.dismissViewControllerAnimated(true, completion: { 
                    self.performSegueWithIdentifier("Login", sender: self)
                })
            })
            let button2 = AlertButton(title: "Practice", imageNames: [], style: .Normal, action: {
                self.dismissViewControllerAnimated(true, completion: {
                    self.performSegueWithIdentifier("GamePlaySegue", sender: self)
                })
            })
            let vc = StoryboardAlertViewControllerFactory().createAlertViewController([button2,button1], title: "Oh Snap!", message: "Please login for your score to be recorded! You will be rewarded with free tickets to start winning prizes!")
            self.presentViewController(vc, animated: true, completion: nil)
            
        }

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "GamePlaySegue" {
            
            let vc = segue.destinationViewController as! GameViewController
            if isCurrentUserLoggedIn() {
                vc.currentTournament = self.tournament
            } else {
                if let center = triviaCurrentDataCenter{
                    vc.currentTournament = center.practiceTournament
                }
            }
        }

    }
    

}
