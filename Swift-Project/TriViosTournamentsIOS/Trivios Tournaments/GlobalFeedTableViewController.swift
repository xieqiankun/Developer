//
//  GlobalFeedTableViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/28/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class GlobalFeedTableViewCell: UITableViewCell {
    @IBOutlet var itemTypeImageView: UIImageView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var prizeNameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var tournamentTalkIcon: TournamentTalkIcon!
    @IBOutlet var prizeImageView: UIImageView!
    
    var tapGesture: UITapGestureRecognizer?
}

class GlobalFeedTableViewController: UITableViewController {
    
    var prizeWinners = Array<gStackPrizeWinner>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //Refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refreshPrizeWinners", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl!)
        
        refreshPrizeWinners()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return prizeWinners.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PrizeCell", forIndexPath: indexPath) as! GlobalFeedTableViewCell
        
        cell.selectionStyle = .None

        // Configure the cell...
        let prizeWinner = prizeWinners[indexPath.row]
        
        
        //prize type image
        //goes here........
        
        //prize name
        cell.prizeNameLabel.text = prizeWinner.prize
        
        //avatar
        let fullAvatarString = prizeWinner.avatar!
        let shortenedAvatarString = fullAvatarString.substringFromIndex(fullAvatarString.startIndex.advancedBy(5))
        cell.avatarImageView.image = UIImage(named: shortenedAvatarString)
        
        //displayname
        cell.usernameLabel.text = prizeWinner.displayName
        
        //time
        if prizeWinner.date != nil {
            cell.timeLabel.text = stringForDateComparedToNow(prizeWinner.date!)
        }
        
        //tourney talk icon
        if prizeWinner.tournament != nil {
            cell.tournamentTalkIcon.tournament = prizeWinner.tournament!
            cell.tapGesture = UITapGestureRecognizer(target: self, action: "goToTournamentTalkPage:")
            if let grs = cell.tournamentTalkIcon.gestureRecognizers {
                for recognizer in grs {
                    cell.tournamentTalkIcon.removeGestureRecognizer(recognizer )
                }
            }
            cell.tournamentTalkIcon.addGestureRecognizer(cell.tapGesture!)
        }
        
        //prize image
        if prizeWinner.image != nil {
            cell.prizeImageView.imageURL = NSURL(string: "http://"+prizeWinner.image!)
        }

        return cell
    }
    
    
    func goToTournamentTalkPage(gesture: UITapGestureRecognizer) {
        let icon = gesture.view as! TournamentTalkIcon
        let tournament = icon.tournament
        performSegueWithIdentifier("TournamentTalk", sender: tournament)
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
        if segue.identifier == "TournamentTalk" {
            let destinationVC = segue.destinationViewController as! TournamentTalkViewController
            destinationVC.tournament = sender as? gStackTournament
        }
    }
    

    
    // MARK: - Refresh Control
    func refreshPrizeWinners() {
        gStackFetchPrizeWinners({
            error, winners in
            dispatch_async(dispatch_get_main_queue(), {
                if error != nil {
                    print("Error fetching prize winners: \(error!)")
                } else {
                    self.prizeWinners = winners!
                    self.tableView.reloadData()
                }
                self.refreshControl?.endRefreshing()
            })
        })
    }
}
