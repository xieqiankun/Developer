//
//  TournamentsTableViewController.swift
//  Trivios Tournaments
//
//  Created by Qiankun Xie on 7/28/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class TournamentTableViewCell: UITableViewCell {
    var tournament: gStackTournament?
    
    @IBOutlet var tournamentImageView: UIImageView!
    @IBOutlet var tournamentImageBorderView: UIImageView!
    @IBOutlet var tournamentTitleLabel: UILabel!
    @IBOutlet var tournamentZoneLabel: UILabel!
    @IBOutlet var tournamentCategoryLabel: UILabel!
    @IBOutlet var infoContainerView: UIView!
    @IBOutlet var infoContainerBackgroundView: UIImageView!
    @IBOutlet var favoriteIcon: UIImageView!
    @IBOutlet var ticketNumberLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var chatButton: TournamentTalkIcon!
    @IBOutlet var ticketImageView: UIImageView!
    
    @IBAction func playButtonPressed() {
        if triviaCurrentUser?.displayName == nil {
            NSNotificationCenter.defaultCenter().postNotificationName("UserMustLogInToPlay", object: nil)
        } else {
        if tournament != nil {
            gStackStartGameForTournament(tournament!, completion: {
                error, game in
                if error != nil {
                    print("Error starting game: \(error!)")
                } else {
                    let tournamentsTVC = (self.superview?.superview as? UITableView)?.dataSource
                    dispatch_async(dispatch_get_main_queue(), { 
                        (tournamentsTVC as? TournamentsTableViewController)?.selectedTournament = self.tournament
                        (tournamentsTVC as? TournamentsTableViewController)?.performSegueWithIdentifier("gamePlaySegue", sender: game)
                    })

                }
            })
        }
        }
    }
}

class TournamentsTableViewController: UITableViewController, gStackTournamentListProtocol {
    
    var tournamentStatus = gStackTournamentStatus.Active
    var tournamentFilter = gStackTournamentFilter.None
    
    var oddCellBackgroundColor = kActiveTournamentsOddCellBackgroundColor
    var evenCellBackgroundColor = kActiveTournamentsEvenCellBackgroundColor
    
    var selectedTournament: gStackTournament?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        //Set colors
        switch tournamentStatus {
        case .Active:
            oddCellBackgroundColor = kActiveTournamentsOddCellBackgroundColor
            evenCellBackgroundColor = kActiveTournamentsEvenCellBackgroundColor
        case .Expired:
            oddCellBackgroundColor = kExpiredTournamentsOddCellBackgroundColor
            evenCellBackgroundColor = kExpiredTournamentsEvenCellBackgroundColor
        case .Upcoming:
            oddCellBackgroundColor = kUpcomingTournamentsOddCellBackgroundColor
            evenCellBackgroundColor = kUpcomingTournamentsEvenCellBackgroundColor
        }
                
        
        if gStackCachedTournaments.count == 0 {
            refreshTournaments()
        }
        
        //Refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refreshTournaments", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl!)
        
        tableView.separatorColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //refresh the table when get the tournaments through login with app id
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTournaments", name: gStackLoginWithAppIDNotificationName, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTournaments", name: "LoggedInUserFromSavedToken", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goToLoginPage", name: "UserMustLogInToPlay", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goToGamePage", name: "GameStarted", object: nil)
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        let tournaments = gStackTournament.tournamentsForStatusInArray(tournamentStatus, filter: tournamentFilter, array: gStackCachedTournaments)
        return tournaments.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(135)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TournamentCell", forIndexPath: indexPath) as! TournamentTableViewCell
        
        // Configure the cell...
        let tournaments = gStackTournament.tournamentsForStatusInArray(tournamentStatus, filter: tournamentFilter, array: gStackCachedTournaments)
        let tournament = tournaments[indexPath.row]
        
        cell.tournament = tournament
        
        //Subviews
        let tournamentImageView = cell.tournamentImageView
        let tournamentImageBorderView = cell.tournamentImageBorderView
        let tournamentTitleLabel = cell.tournamentTitleLabel
        let tournamentZoneLabel = cell.tournamentZoneLabel
        let tournamentCategoryLabel = cell.tournamentCategoryLabel
        let infoContainerView = cell.infoContainerView
        let infoContainerBackgroundView = cell.infoContainerBackgroundView
        let favoriteIcon = cell.favoriteIcon
        let ticketNumberLabel = cell.ticketNumberLabel
        let playButton = cell.playButton
        let ticketImageView = cell.ticketImageView
        let chatButton = cell.chatButton
        
        //Background Color
        var color = evenCellBackgroundColor
        if indexPath.row % 2 == 0 {
            color = oddCellBackgroundColor
        }

        cell.backgroundColor = color
        
        //Tournament Image
        if let tournamentPrize = tournament.prizes?.first {
            if let imageURLString = tournamentPrize.image {
                tournamentImageView.imageURL = NSURL(string: "http://" + imageURLString)
                tournamentImageView.layer.cornerRadius = tournamentImageView.frame.width/2
                tournamentImageView.layer.masksToBounds = true
            }
        }
        
        
        //Tournament Title
        tournamentTitleLabel.textColor = color
        tournamentTitleLabel.text = tournament.name
        tournamentTitleLabel.adjustsFontSizeToFitWidth = true
        
        
        //Tournament Category and Zone
        tournamentCategoryLabel.textColor = color
        tournamentCategoryLabel.adjustsFontSizeToFitWidth = true
        tournamentZoneLabel.textColor = color
        tournamentZoneLabel.adjustsFontSizeToFitWidth = true
        if let tournamentQuestionInfo = tournament.questions {
            tournamentCategoryLabel.text = tournamentQuestionInfo.category
            tournamentZoneLabel.text = tournamentQuestionInfo._zone
        }
        
        
        //Favorite Icon
        favoriteIcon.image = UIImage(named: "Favorite-Unselected")
        favoriteIcon.tintColor = color
        if let grs = favoriteIcon.gestureRecognizers {
            for recognizer in grs {
                favoriteIcon.removeGestureRecognizer(recognizer )
            }
        }
        favoriteIcon.userInteractionEnabled = false

        favoriteIcon.image = favoriteIcon.image?.imageWithRenderingMode(.AlwaysTemplate)
        let tapGesture = UITapGestureRecognizer(target: self, action: "favoriteIconTapped:")
        favoriteIcon.addGestureRecognizer(tapGesture)
        favoriteIcon.userInteractionEnabled = true
        
        //Number of Tickets
        ticketNumberLabel.textColor = color
        ticketNumberLabel.text = tournament.buyin?.stringValue
        
        //Play Button
        if tournamentStatus != .Active {
            playButton.removeFromSuperview()
        }
        
        //Ticket icon
        ticketImageView.tintColor = color
        ticketImageView.image = ticketImageView.image?.imageWithRenderingMode(.AlwaysTemplate)
        
        //Chat button
        chatButton.tintColor = color
        chatButton.tournament = cell.tournament
        if let grs = chatButton.gestureRecognizers {
            for recognizer in grs {
                chatButton.removeGestureRecognizer(recognizer )
            }
        }
        let tapGesture2 = UITapGestureRecognizer(target: self, action: "chatButtonTapped:")
        chatButton.addGestureRecognizer(tapGesture2)
        

        return cell
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let tCell = cell as! TournamentTableViewCell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedTournament = gStackTournament.tournamentsForStatusInArray(tournamentStatus, filter: tournamentFilter, array: gStackCachedTournaments)[indexPath.row]
        
        performSegueWithIdentifier("ShowTournamentDetails", sender: nil)
    }
    
    
    func chatButtonTapped(gesture: UITapGestureRecognizer) {
        let chatButton = gesture.view! as! TournamentTalkIcon
        selectedTournament = chatButton.tournament!
        performSegueWithIdentifier("TournamentTalk", sender: nil)
    }
    
    
    func favoriteIconTapped(gesture: UITapGestureRecognizer) {
        let cell = gesture.view?.superview?.superview?.superview as! TournamentTableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        let tournaments = gStackTournament.tournamentsForStatusInArray(tournamentStatus, filter: tournamentFilter, array: gStackCachedTournaments)
        let tournament = tournaments[indexPath.row]
        
    }
    
    
    //MARK: - Start Game
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowTournamentDetails" {
            let detailController = segue.destinationViewController as! TournamentDetailsViewController
            detailController.tournament = selectedTournament
        }
        
        else if segue.identifier == "gamePlaySegue" {
            let destinationVC = segue.destinationViewController as! GamePlayViewController
            destinationVC.tournament = selectedTournament
            destinationVC.game = sender as? gStackGame
        }
        
        else if segue.identifier == "TournamentTalk" {
            let destinationVC = segue.destinationViewController as! TournamentTalkViewController
            destinationVC.tournament = selectedTournament
        }
    }
    
    
    
    
    // MARK: - Refresh Control
    func refreshTournaments() {
        //Load tournaments
            gStackFetchTournaments({
                error, _ in
                if error != nil {
                    print("Error fetching tournaments: \(error!)")
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })
            })
    }

}
