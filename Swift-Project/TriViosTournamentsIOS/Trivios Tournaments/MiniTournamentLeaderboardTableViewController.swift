//
//  MiniTournamentLeaderboardTableViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/3/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class MiniTournamentLeaderboardTableViewController: UITableViewController {
    
    enum LeaderboardFilter {
        case Rank
        case Player
        case NumberCorrect
        case AverageTime
        case Region
    }
    
    var leaderboard: gStackTournamentLeaderboard?
    var tournament: gStackTournament?
    
    var fullscreen = false
    
    var leaderboardFilter = LeaderboardFilter.Rank
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if let count = leaderboard?.leaders.count {
            return count > 20 && !fullscreen ? 20 : count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if fullscreen {
            let headerView = tableView.dequeueReusableCellWithIdentifier("SectionHeader")
            return headerView
        }
        else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if fullscreen {
            return 45
        }
        else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if fullscreen {
            return 45
        }
        else {
            return 65
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if fullscreen == false {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) 
            
            // Configure the cell...
            let placeLabel = cell.viewWithTag(1) as! UILabel
            let avatarImageView = cell.viewWithTag(2) as! UIImageView
            let usernameLabel = cell.viewWithTag(3) as! UILabel
            let userFlagImageView = cell.viewWithTag(4) as! UIImageView
            let userLocationLabel = cell.viewWithTag(5) as! UILabel
            let correctAnswersLabel = cell.viewWithTag(6) as! UILabel
            let averageTimeLabel = cell.viewWithTag(7) as! UILabel
            let prizeImageView = cell.viewWithTag(8) as! UIImageView
            
            cell.backgroundColor = randomColor()
            
            if leaderboard != nil {
                let leader = leaderboard!.leaders[indexPath.row]
                
                //Place
                placeLabel.text = stringForPlace(indexPath.row+1)
                placeLabel.adjustsFontSizeToFitWidth = true
                
                //Avatar
                if var avatarImageString = leader.avatar {
                    let index = avatarImageString.startIndex.advancedBy(5)
                    avatarImageString = avatarImageString.substringFromIndex(index)
                    avatarImageView.image = UIImage(named: avatarImageString)
                }
                
                //Username
                usernameLabel.text = leader.displayName
                
                //Region
                if let location = leader.location {
                    if location.country == "United States" {
                        if let region = location.region {
                            userLocationLabel.text = "\(region), USA"
                        } else {
                            userLocationLabel.text = location.country
                        }
                    }
                    else {
                        userLocationLabel.text = location.country
                    }
                    
                    //Flag
                    if location.country != nil {
                        userFlagImageView.image = UIImage(named: location.country!)
                    }
                }
                
                //Number correct
                if let numberCorrect = leader.correct {
                    correctAnswersLabel.text = numberCorrect.stringValue
                    
                    //Average Time
                    if let correctTime = leader.correctTime {
                        let averageTime = correctTime.doubleValue / Double(numberCorrect.doubleValue * 1000)
                        averageTimeLabel.text = String(format: "%.2f", averageTime)
                    }
                }
                
                //Prize
                if let prizes = tournament!.prizes {
                    if prizes.count > indexPath.row {
                        let prize = prizes[Int(indexPath.row)]
                        if let prizeImageString = prize.image {
                            let prizeImageURLString = "http://" + prizeImageString
                            prizeImageView.imageURL = NSURL(string: prizeImageURLString)
                        }
                    }
                }
            }
            else {
                //Wait, refresh leaderboard. Wait... does this do anything?
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(0.25) * Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserCell2", forIndexPath: indexPath) 
            
            let placeLabel = cell.viewWithTag(1) as! UILabel
            let flagImageView = cell.viewWithTag(2) as! UIImageView
            let avatarImageView = cell.viewWithTag(3) as! UIImageView
            let usernameLabel = cell.viewWithTag(4) as! UILabel
            let correctAnswersLabel = cell.viewWithTag(5) as! UILabel
            let averageTimeLabel = cell.viewWithTag(6) as! UILabel
            let regionLabel = cell.viewWithTag(7) as! UILabel
            
            if leaderboard != nil {
                if let leader = sortedLeaderboard()?.leaders[indexPath.row] {
                    
                    //Place
                    placeLabel.text = String(leaderboard!.indexOfLeader(leader)!+1) + "."
                    
                    //Avatar
                    if var avatarImageString = leader.avatar {
                        let index = avatarImageString.startIndex.advancedBy(5)
                        avatarImageString = avatarImageString.substringFromIndex(index)
                        avatarImageView.image = UIImage(named: avatarImageString)
                    }
                    
                    //Username
                    usernameLabel.text = leader.displayName
                    
                    //Highlight username for logged in user
                    if isCurrentUserLoggedIn() && leader.displayName == triviaCurrentUser!.displayName {
                        placeLabel.textColor = UIColor.yellowColor()
                        usernameLabel.textColor = UIColor.yellowColor()
                        correctAnswersLabel.textColor = UIColor.yellowColor()
                        averageTimeLabel.textColor = UIColor.yellowColor()
                        regionLabel.textColor = UIColor.yellowColor()
                    }
                    
                    //Region
                    if let location = leader.location {
                        if location.country == "United States" {
                            if let region = location.region {
                                regionLabel.text = "\(region), USA"
                            } else {
                                regionLabel.text = location.country
                            }
                        }
                        else {
                            regionLabel.text = location.country
                        }
                        
                        //Flag
                        if location.country != nil {
                            flagImageView.image = UIImage(named: location.country!)
                        }
                    }
                    
                    //Number correct
                    if let numberCorrect = leader.correct {
                        correctAnswersLabel.text = numberCorrect.stringValue
                        
                        //Average Time
                        if let correctTime = leader.correctTime {
                            let averageTime = correctTime.doubleValue / Double(numberCorrect.doubleValue * 1000)
                            averageTimeLabel.text = String(format: "%.2f", averageTime)
                        }
                    }
                }
            }
            
            return cell
        }
    }
    
    
    func changedFullscreen() {
        tableView.reloadData()
        
        if fullscreen {
            tableView.userInteractionEnabled = true
            
            let newRefreshControl = UIRefreshControl()
            newRefreshControl.addTarget(self, action: "refreshData", forControlEvents: .ValueChanged)
            refreshControl = newRefreshControl
        }
        else {
            tableView.userInteractionEnabled = false
            
            if let count = leaderboard?.leaders.count where count > 0 {
                tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
            }
            
            refreshControl = nil
        }
    }
    
    func shouldAllowUserInteraction(shouldAllow: Bool) {
        tableView.userInteractionEnabled = shouldAllow
        if shouldAllow == true {
            let newRefreshControl = UIRefreshControl()
            newRefreshControl.addTarget(self, action: "refreshData", forControlEvents: .ValueChanged)
            refreshControl = newRefreshControl
        }
        else {
            refreshControl = nil
        }
    }
    
    func refreshData() {
        if tournament != nil {
            gStackFetchLeaderboardForTournament(tournament!, completion: {
                error, leaderboard in
                if error != nil {
                    print("Error fetching leaderboard: \(error!)")
                } else {
                    self.leaderboard = leaderboard
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })
            })
        }
    }
    
    
    var sortOrderDefault = true
    var selectedButtonTag = 1 //Why the FUCK is this necessary? Because .selected is not working, that's why
    
    @IBAction func filterSelected(sender: UIButton) {
//        if sender.selected == false {
//            sender.selected = true
        if sender.tag != selectedButtonTag {
            selectedButtonTag = sender.tag
            
//            for view in (sender.superview!.subviews as! Array<UIView>) {
//                if view.tag != 0 && view.tag != sender.tag {
//                    (view as! UIButton).selected = false
//                }
//            }
            
            switch sender.tag {
            case 1:
                leaderboardFilter = .Rank
            case 2:
                leaderboardFilter = .Player
            case 3:
                leaderboardFilter = .NumberCorrect
            case 4:
                leaderboardFilter = .AverageTime
            case 5:
//                leaderboardFilter = .Region
                break
            default:
                break
            }
            
            sortOrderDefault = true
            
            tableView.reloadData()
        }
        else {
            if sortOrderDefault == true {
                sortOrderDefault = false
            }
            else {
                sortOrderDefault = true
            }
            
            tableView.reloadData()
        }
    }
    
    func sortedLeaderboard() -> gStackTournamentLeaderboard? {
        if var sortedArray = leaderboard?.leaders {
            switch leaderboardFilter {
            case .Rank:
                break
            case .Player:
                sortedArray.sortInPlace({
                    leader1, leader2 in
                    return leader1.displayName!.lowercaseString < leader2.displayName!.lowercaseString
                })
            case .NumberCorrect:
                sortedArray.sortInPlace({
                    leader1, leader2 in
                    return leader1.correct!.doubleValue > leader2.correct!.doubleValue
                })
            case .AverageTime:
                sortedArray.sortInPlace({
                    leader1, leader2 in
                    let numCorrect1 = leader1.correct!.doubleValue
                    let numCorrect2 = leader2.correct!.doubleValue
                    let correctTime1 = leader1.correctTime!.doubleValue
                    let correctTime2 = leader2.correctTime!.doubleValue
                    let averageTime1 = correctTime1 / Double(numCorrect1 * 1000)
                    let averageTime2 = correctTime2 / Double(numCorrect2 * 1000)
                    return averageTime1 < averageTime2
                })
            case .Region:
                break
            }
            
            if sortOrderDefault == false {
                sortedArray = Array(sortedArray.reverse())
            }
            
            return gStackTournamentLeaderboard(_leaders: sortedArray)
        }
        return nil
    }
    
    func indexOfLeaderInLeaderboard(leader: Dictionary<String,AnyObject>, aLeaderboard: Array<Dictionary<String,AnyObject>>) -> Int {
        for idx in 0...aLeaderboard.count-1 {
            let aLeader = aLeaderboard[idx]
            if leader["_id"] as! String == aLeader["_id"] as! String {
                return idx
            }
        }
        return -1
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    
    func stringForPlace(place: Int) -> String {
        switch place {
        case 1:
            return "1st"
        case 2:
            return "2nd"
        case 3:
            return "3rd"
        default:
            return String(place) + "th"
        }
    }
}
