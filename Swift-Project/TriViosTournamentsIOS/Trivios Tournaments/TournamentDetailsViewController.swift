//
//  TournamentDetailsViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/3/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit
import MapKit

class TournamentDetailsViewController: UIViewController {
    
    @IBOutlet var tournamentInfoSuperview: UIView!
    @IBOutlet var tournamentNameLabel: UILabel!
    @IBOutlet var prizeDescriptionLabel: UILabel! //This is actually the tournament description
    @IBOutlet var prizeImageView: UIImageView!
    @IBOutlet var tournamentCategoryLabel: UILabel!
    @IBOutlet var tournamentSubcategoryLabel: UILabel!
    @IBOutlet var tournamentTalkIcon: TournamentTalkIcon!
    @IBOutlet var tournamentTimeRemainingLabel: UILabel!
    @IBOutlet var tournamentNumberOfQuestionsLabel: UILabel!
    @IBOutlet var tournamentEntryFeeLabel: UILabel!
    @IBOutlet var tournamentNumberOfEntriesLabel: UILabel!
    @IBOutlet var tournamentModeLabel: UILabel!
    @IBOutlet var tournamentMapView: MKMapView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var leaderboardContainerView: UIView!
    
    var tournament: gStackTournament?
    
    var embeddedViewController: MiniTournamentLeaderboardTableViewController?
    
    var embeddedLeaderboardYPosition = CGFloat(0)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        populateTournamentInformation()
        
        navigationItem.title = "TOURNAMENT"
        
        tournamentTalkIcon.tournament = tournament
        let tapGesture = UITapGestureRecognizer(target: self, action: "goToTalkPage")
        tournamentTalkIcon.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Register for notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goToLoginPage", name: "UserMustLogInToPlay", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goToGamePage", name: "GameStarted", object: nil)
        
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
        
        populateTournamentInformation()
    }
    
    var gotOriginalPosition = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !gotOriginalPosition {
            embeddedLeaderboardYPosition = leaderboardContainerView.frame.origin.y
            leaderboardContainerView.translatesAutoresizingMaskIntoConstraints = true
            gotOriginalPosition = true
        }
    }
    
    
    func populateTournamentInformation() {
        if tournament != nil {
            if tournament!.status() != .Active {
                playButton.hidden = true
                playButton.enabled = false
            }
            
            tournamentNameLabel.text = tournament?.name
            
            if let prize = tournament?.prizes?.first {
                prizeDescriptionLabel.text = prize.name
                
                if let imageString = prize.image {
                    let imageURLString = "http://" + imageString
                    prizeImageView.imageURL = NSURL(string: imageURLString)
                }
            }
            
            if let questions = tournament?.questions {
                tournamentCategoryLabel.text = questions._zone
                tournamentSubcategoryLabel.text = questions.category
                if let numberOfQuestions = questions.num {
                    tournamentNumberOfQuestionsLabel.text = "\(numberOfQuestions) Questions"
                }
            }
        
            tournamentTimeRemainingLabel.text = stringForTournamentTimeComparedToNow(tournament!)
            
            if let numberOfTicketsToEnter = tournament?.buyin {
                tournamentEntryFeeLabel.text = "\(numberOfTicketsToEnter) Tickets to Enter"
            }
            
            if let numberOfEntries = tournament?.entries {
                tournamentNumberOfEntriesLabel.text = "\(numberOfEntries) Entries"
            }
            
            if let location = tournament?.location {
                if let latitude = location.latitude {
                    let longitude = location.longitude!
                    let radius = location.radius!
                    
                    let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue), radius.doubleValue, radius.doubleValue)
                    tournamentMapView.setRegion(region, animated: true)
                }
                else {
                    tournamentMapView.setRegion(MKCoordinateRegionForMapRect(MKMapRectWorld), animated: true)
                }
            } else {
                tournamentMapView.setRegion(MKCoordinateRegionForMapRect(MKMapRectWorld), animated: true)
            }
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EmbedLeaderboardSegue" {
            embeddedViewController = segue.destinationViewController as? MiniTournamentLeaderboardTableViewController
            embeddedViewController?.tournament = tournament
        }
        
        else if segue.identifier == "gamePlaySegue" {
            let destinationVC = segue.destinationViewController as! GamePlayViewController
            destinationVC.tournament = tournament
            destinationVC.game = sender as? gStackGame
        }
        
        else if segue.identifier == "TournamentTalk" {
            let destinationVC = segue.destinationViewController as! TournamentTalkViewController
            destinationVC.tournament = tournament
        }
    }
    
    
   
    
    @IBAction func playButtonPressed() {
        if triviaCurrentUser == nil {
            NSNotificationCenter.defaultCenter().postNotificationName("UserMustLogInToPlay", object: nil)
        } else {
        if tournament != nil {
            gStackStartGameForTournament(tournament!, completion: {
                error, game in
                if error != nil {
                    print("Error starting game: \(error!)")
                } else {
                    self.performSegueWithIdentifier("gamePlaySegue", sender: game)
                }
            })
        }
        }
    }
    
    func goToLoginPage() {
        if view.window != nil {
            performSegueWithIdentifier("loginSegue", sender: nil)
        }
    }
    
    func goToGamePage() {
        if view.window != nil {
            performSegueWithIdentifier("gamePlaySegue", sender: nil)
        }
    }
    
    
    func goToTalkPage() {
        performSegueWithIdentifier("TournamentTalk", sender: nil)
    }
    
    
    
    //MARK: - Drag Up Leaderboard
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
                        self.leaderboardContainerView.frame = CGRectMake(0, 60, self.view.frame.width, self.view.frame.height-60-self.tabBarController!.tabBar.frame.height)
                    })
                    
                    embeddedViewController?.fullscreen = true
                    embeddedViewController?.changedFullscreen()

                    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .Done, target: self, action: "closeLeaderboard")
                    
                    leaderboardFullscreen = true
                }
            }
        }
        movingLeaderboard = false
    }
    
    func closeLeaderboard() {
        navigationItem.rightBarButtonItem = nil
        
        embeddedViewController?.fullscreen = false
        embeddedViewController?.changedFullscreen()
        
        UIView.animateWithDuration(0.5, animations: {
            self.leaderboardContainerView.frame = CGRectMake(0, self.embeddedLeaderboardYPosition, self.view.frame.width, self.leaderboardContainerView.frame.height)
            }, completion: {
                completed in
                self.navigationItem.rightBarButtonItem = nil
                self.leaderboardFullscreen = false
                self.leaderboardContainerView.frame = CGRectMake(0, self.embeddedLeaderboardYPosition, self.view.frame.width, self.view.frame.height-CGFloat(self.embeddedLeaderboardYPosition))
        })
    }
}
