//
//  GameOverViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/13/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBOutlet var prizeNameLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var prizeImageView: UIImageView!
    @IBOutlet var correctNumberLabel: UILabel!
    @IBOutlet var averageTimeLabel: UILabel!
    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet var leaderboardContainerView: UIView!
    
    @IBOutlet var playAgainButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var reviewButton: UIButton!
    @IBOutlet var tournamentTalkButton: UIButton!
    @IBOutlet var playAgainLabel: UILabel!
    @IBOutlet var shareLabel: UILabel!
    @IBOutlet var reviewLabel: UILabel!
    
    @IBOutlet var correctLabelLabel: UILabel!
    @IBOutlet var timeLabelLabel: UILabel!
    
    var tournament: gStackTournament?
    var avatarImageString = ""
    var numberOfCorrectAnswers = 0
    var averageTime = 0.0
    
    //For review page
    var questions: Array<gStackGameQuestion>?
    var correctAnswers: Array<gStackGameCorrectAnswer>?
    var answerDotsView: CorrectAnswerDotsView?
    
    var embeddedViewController: MiniTournamentLeaderboardTableViewController?
    
    var embeddedLeaderboardYPosition = CGFloat(0)

    var presenterViewController: GamePlayViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureViewElements()
        
        //Refresh Data
        if tournament != nil {
            gStackFetchLeaderboardForTournament(tournament!, completion: {
                error, leaderboard in
                if error != nil {
                    print("Error fetching leaderboard: \(error!)")
                } else {
                    self.embeddedViewController?.leaderboard = leaderboard
                    dispatch_async(dispatch_get_main_queue(), {
                        self.embeddedViewController?.tableView.reloadData()
                    })
                }
            })
        }
        
        configureDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(animated)        
    }
    
    
    func configureDisplay() {
        let backgroundColor = UIColor(patternImage: UIImage(named: "gameplay-background")!)
        view.backgroundColor = backgroundColor
        
        prizeNameLabel.textColor = UIColor.whiteColor()
        correctNumberLabel.textColor = UIColor.whiteColor()
        averageTimeLabel.textColor = UIColor.whiteColor()
        
        prizeImageView.layer.cornerRadius = prizeImageView.frame.width/2
        prizeImageView.layer.masksToBounds = true
        
        playAgainButton.backgroundColor = UIColor.clearColor()
        shareButton.backgroundColor = UIColor.clearColor()
        reviewButton.backgroundColor = UIColor.clearColor()
        tournamentTalkButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        playAgainLabel.textColor = UIColor.whiteColor()
        shareLabel.textColor = UIColor.whiteColor()
        reviewLabel.textColor = UIColor.whiteColor()
        
        correctLabelLabel.textColor = UIColor.whiteColor()
        timeLabelLabel.textColor = UIColor.whiteColor()
    }
    
    var gotOriginalPosition = false
    var firstLayout = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !gotOriginalPosition {
            embeddedLeaderboardYPosition = leaderboardContainerView.frame.origin.y
            leaderboardContainerView.translatesAutoresizingMaskIntoConstraints = true
            gotOriginalPosition = true
        }
        
        let yCoordinate = correctNumberLabel.frame.origin.y
        if firstLayout == true && yCoordinate >= 0 {
            firstLayout = false
            
            drawCircles()
        }
    }
    
    
    func drawCircles() {
        for label in [correctNumberLabel,averageTimeLabel] {
            let circleLayer = CAShapeLayer()
            let padding = CGFloat(5)
            circleLayer.path = UIBezierPath(ovalInRect: CGRectMake(label.frame.origin.x-padding, label.frame.origin.y-padding, label.frame.width+padding*2, label.frame.height+padding*2)).CGPath
            circleLayer.fillColor = kUnansweredBackgroundColor.CGColor
            circleLayer.strokeColor = kGamePageTextColor.CGColor
            circleLayer.lineWidth = 5
            view.layer.insertSublayer(circleLayer, atIndex: 0)
        }
        for image in [avatarImageView,prizeImageView] {
            let circleLayer = CAShapeLayer()
            var padding = CGFloat(10)
            if image == prizeImageView {
                padding = CGFloat(15)
            }
            circleLayer.path = UIBezierPath(ovalInRect: CGRectMake(image.frame.origin.x-padding, image.frame.origin.y-padding, image.frame.width+padding*2, image.frame.height+padding*2)).CGPath
            circleLayer.fillColor = UIColor.whiteColor().CGColor
            circleLayer.strokeColor = kGamePageTextColor.CGColor
            circleLayer.lineWidth = 5
            view.layer.insertSublayer(circleLayer, atIndex: 0)
        }
        for button in [playAgainButton,shareButton,reviewButton,tournamentTalkButton] {
            let horizontalPadding = CGFloat(15)
            let verticalPadding = CGFloat(3)
            let ovalLayer = CAShapeLayer()
            ovalLayer.path = UIBezierPath(roundedRect: CGRectMake(button.frame.origin.x-horizontalPadding, button.frame.origin.y-verticalPadding, button.frame.width+horizontalPadding*2, button.frame.height+verticalPadding*2), cornerRadius: button.frame.height+verticalPadding*2).CGPath
            ovalLayer.fillColor = kUnansweredBackgroundColor.CGColor
            ovalLayer.strokeColor = kGamePageTextColor.CGColor
            ovalLayer.lineWidth = 1
            view.layer.insertSublayer(ovalLayer, atIndex: 0)
        }
    }
    
    
    
    func configureViewElements() {
        if let tournamentPrize = tournament?.prizes?.first {
            prizeNameLabel.text = tournamentPrize.name
            if let prizeImageString = tournamentPrize.image {
                let imageURLString = "http://" + prizeImageString
                prizeImageView.imageURL = NSURL(string: imageURLString)
            }
        }
        
        avatarImageView.image = UIImage(named: avatarImageString)
        
        correctNumberLabel.text = String(numberOfCorrectAnswers)
        
        averageTimeLabel.text = String(format: "%.2f", arguments: [averageTime])
        
        navItem.title = tournament?.name
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EmbedLeaderboardSegue" {
            embeddedViewController = segue.destinationViewController as? MiniTournamentLeaderboardTableViewController
            embeddedViewController?.tournament = tournament
            embeddedViewController?.fullscreen = true
            embeddedViewController?.shouldAllowUserInteraction(false)
        }
        
        else if segue.identifier == "TournamentTalk" {
            let destinationVC = segue.destinationViewController as! TournamentTalkViewController
            destinationVC.tournament = tournament
            destinationVC.modal = true
        }
        
        else if segue.identifier == "ReviewQuestions" {
            let destinationVC = segue.destinationViewController as! ReviewQuestionsPageViewController
            destinationVC.questions = questions!
            destinationVC.correctAnswers = correctAnswers!
            destinationVC.answerDotsView = answerDotsView
            destinationVC.tournament = tournament
        }
    }


    @IBAction func goHome() {
        dismissViewControllerAnimated(true, completion: {
            completed in
            self.presenterViewController?.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    @IBAction func playAgainButtonPressed() {
        if tournament != nil {
            gStackStartGameForTournament(tournament!, completion: {
                error, game in
                if error != nil {
                    print("Error starting the game: \(error!)")
                } else {
                    self.presenterViewController?.startThings()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }
    
    
    
    //MARK: - Status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    
    //MARK: - Drag Up Leaderboard - copied from TournamentDetailsViewController
    var movingLeaderboard = false
    var leaderboardFullscreen = false
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let yCoordinate = touch.locationInView(view).y
            if !leaderboardFullscreen && yCoordinate > embeddedLeaderboardYPosition {
                movingLeaderboard = true
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if movingLeaderboard {
            if let touch = touches.first {
                let yCoordinate = touch.locationInView(view).y
                if yCoordinate < embeddedLeaderboardYPosition {
                    leaderboardContainerView.frame = CGRectMake(0, yCoordinate, view.frame.width, view.frame.height-CGFloat(yCoordinate))
                    movingLeaderboard = true
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if movingLeaderboard {
            if let touch = touches.first {
                let yCoordinate = touch.locationInView(view).y
                let pointOfNoReturn = view.frame.height / 2
                if yCoordinate > pointOfNoReturn {
                    closeLeaderboard()
                }
                else {
                    UIView.animateWithDuration(0.5, animations: {
                        self.leaderboardContainerView.frame = CGRectMake(0, 40, self.view.frame.width, self.view.frame.height-40)
                    })
                    
//                    embeddedViewController?.fullscreen = true
//                    embeddedViewController?.changedFullscreen()
                    embeddedViewController?.shouldAllowUserInteraction(true)
                    
                    navItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .Done, target: self, action: "closeLeaderboard")
                    
                    leaderboardFullscreen = true
                }
            }
        }
        movingLeaderboard = false
    }
    
    func closeLeaderboard() {
        navItem.rightBarButtonItem = nil
        
//        embeddedViewController?.fullscreen = false
//        embeddedViewController?.changedFullscreen()
        embeddedViewController?.shouldAllowUserInteraction(false)
        
        UIView.animateWithDuration(0.5, animations: {
            self.leaderboardContainerView.frame = CGRectMake(0, self.embeddedLeaderboardYPosition, self.view.frame.width, self.leaderboardContainerView.frame.height)
            }, completion: {
                completed in
                self.navItem.rightBarButtonItem = nil
                self.leaderboardFullscreen = false
                self.leaderboardContainerView.frame = CGRectMake(0, self.embeddedLeaderboardYPosition, self.view.frame.width, self.view.frame.height-CGFloat(self.embeddedLeaderboardYPosition))
        })
    }
    
    

}
