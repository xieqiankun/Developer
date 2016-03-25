//
//  TournamentsCollectionViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/7/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

let reuseIdentifier = "TournamentCell"

class TournamentCollectionViewCell: UICollectionViewCell {
    var tournament: gStackTournament?
    
    @IBOutlet var prizeImageView: UIImageView!
    @IBOutlet var tournamentTitleLabel: UILabel!
    @IBOutlet var favoriteImageView: UIImageView!
    @IBOutlet var numberOfTicketsLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var chatButton: UIButton!
    
    @IBAction func playButtonPressed() {
        if tournament != nil {
            gStackStartGameForTournament(tournament!, completion: {
                error, game in
                if error != nil {
                    print("Error starting game: \(error!)")
                } else {
                    let tournamentsTVC = (self.superview?.superview as? UITableView)?.dataSource
                    (tournamentsTVC as? TournamentsCollectionViewController)?.selectedTournament = self.tournament
                    (tournamentsTVC as? TournamentsCollectionViewController)?.performSegueWithIdentifier("gamePlaySegue", sender: game)
                }
            })
        }
    }
    
    @IBAction func chatButtonPressed() {
        if tournament != nil {
            let tournamentsTVC = (self.superview?.superview as? UITableView)?.dataSource
            (tournamentsTVC as? TournamentsCollectionViewController)?.selectedTournament = self.tournament
            (tournamentsTVC as? TournamentsCollectionViewController)?.performSegueWithIdentifier("TournamentTalk", sender: nil)
        }
    }
}

class TournamentsCollectionViewController: UICollectionViewController, gStackTournamentListProtocol {
    
    var tournamentStatus = gStackTournamentStatus.Active
    var tournamentFilter = gStackTournamentFilter.None
    
    var textColor = kActiveTournamentsOddCellBackgroundColor
    
    var selectedTournament: gStackTournament?
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        //Set colors
        switch tournamentStatus {
        case .Active:
            textColor = kActiveTournamentsOddCellBackgroundColor
        case .Expired:
            textColor = kExpiredTournamentsOddCellBackgroundColor
        case .Upcoming:
            textColor = kUpcomingTournamentsOddCellBackgroundColor
        }
        
        if gStackCachedTournaments.count == 0 {
            refreshTournaments()
        }
        
        //Refresh control
        refreshControl.addTarget(self, action: "refreshTournaments", forControlEvents: .ValueChanged)
        collectionView?.addSubview(refreshControl)
        collectionView?.alwaysBounceVertical = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTournaments", name: "LoggedInUserFromSavedToken", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goToLoginPage", name: "UserMustLogInToPlay", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goToGamePage", name: "GameStarted", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tournaments = gStackTournament.tournamentsForStatusInArray(tournamentStatus, filter: tournamentFilter, array: gStackCachedTournaments)
        return tournaments.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TournamentCollectionViewCell
    
        // Configure the cell
        
        //Get the shared manager
        let tournaments = gStackTournament.tournamentsForStatusInArray(tournamentStatus, filter: tournamentFilter, array: gStackCachedTournaments)
        let tournament = tournaments[indexPath.row]
        
        cell.tournament = tournament

        //Subviews
        let tournamentImageView = cell.prizeImageView
        let tournamentTitleLabel = cell.tournamentTitleLabel
        let favoriteIcon = cell.favoriteImageView
        let ticketNumberLabel = cell.numberOfTicketsLabel
        let playButton = cell.playButton

        //Tournament Image
        tournamentImageView.image = nil
        if let tournamentPrize = tournament.prizes?.first {
            if let imageURLString = tournamentPrize.image {
                tournamentImageView.imageURL = NSURL(string: "http://" + imageURLString)
            }
        }
        
        
        //Tournament Title
        tournamentTitleLabel.textColor = textColor
        tournamentTitleLabel.text = tournament.name
        
        //Favorite Icon
        favoriteIcon.backgroundColor = UIColor.grayColor()
        if let grs = favoriteIcon.gestureRecognizers {
            for recognizer in grs {
                favoriteIcon.removeGestureRecognizer(recognizer )
            }
        }
        favoriteIcon.userInteractionEnabled = false

        let tapGesture = UITapGestureRecognizer(target: self, action: "favoriteIconTapped:")
        favoriteIcon.addGestureRecognizer(tapGesture)
        favoriteIcon.userInteractionEnabled = true
        
        //Number of Tickets
        ticketNumberLabel.textColor = textColor
        ticketNumberLabel.text = tournament.buyin?.stringValue
        
        
        //Play Button
        if tournamentStatus != .Active {
            playButton.hidden = true
        }
        else {
            playButton.hidden = false
        }
        
    
        return cell
    }
    
    
    func favoriteIconTapped(gesture: UITapGestureRecognizer) {
        let cell = gesture.view?.superview as! TournamentCollectionViewCell
        let indexPath = collectionView!.indexPathForCell(cell)!
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
    
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedTournament = gStackTournament.tournamentsForStatusInArray(tournamentStatus, filter: tournamentFilter, array: gStackCachedTournaments)[indexPath.row]

        
        performSegueWithIdentifier("ShowTournamentDetails", sender: nil)
    }
    
    
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
                    self.collectionView?.reloadData()
                    self.refreshControl.endRefreshing()
                })
            })
    }

}
