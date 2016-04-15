//
//  TournamentsTableViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/4/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

var TournamentWillAppearNotificationName = "triviaTournamentWillAppear"
var TournamentDidSelectNotificationName = "triviaTournamentDidSelect"

class TournamentTableViewCell: UITableViewCell {
    
    //For UI
    @IBOutlet weak var tableCellView: UIView!
    @IBOutlet weak var prizeImageView: UIImageView!
    
    @IBOutlet weak var myLabel: UILabel!
    
    
    var backgroundImageView: UIImageView?
    
    func changeColorWhenSelect(){
        let view = tableCellView.subviews[0] as! UIImageView
        view.image = UIImage(named: "TournamentItemTouched.png")
        
    }
    
    func changeCorlorWhenDeselect(){
        let view = tableCellView.subviews[0] as! UIImageView
        view.image = UIImage(named: "TournamentItemUntouched.png")
    }
    
    func setupCellBackground(){
        
        if backgroundImageView != nil{
            backgroundImageView?.removeFromSuperview()
        }
        
        let tableWidth = tableCellView.bounds.size.width
        let tableHeight = tableCellView.bounds.size.height
        
        let tableImageViewBackground = UIImageView(frame: CGRectMake(0, 0, tableWidth, tableHeight))
        tableImageViewBackground.image = UIImage(named: "TournamentItemUntouched.png")
        tableImageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImageView = tableImageViewBackground
        
        tableCellView.addSubview(tableImageViewBackground)
        tableCellView.sendSubviewToBack(tableImageViewBackground)
        
    }
    
    func setRoundCorner(){
        
        prizeImageView.layer.borderColor = UIColor.whiteColor().CGColor
        prizeImageView.layer.cornerRadius = 8
        prizeImageView.layer.masksToBounds = true
        prizeImageView.layer.borderWidth = 2.0
        
    }
    
    
}


class TournamentsTableViewController: UITableViewController, gStackTournamentListProtocol {
    
    
    var tournamentStatus = gStackTournamentStatus.Active
    var tournamentFilter = gStackTournamentFilter.None
    
    var tournaments: [gStackTournament] = [gStackTournament]()
    
    //for display logic control
    var isFirstShow = false
    var isNeedChangeForFirstCell = false
    
    var selectedTournament: gStackTournament?{
        didSet{
            // Contain the concurrency between different views
            NSNotificationCenter.defaultCenter().postNotificationName(TournamentDidSelectNotificationName, object: self, userInfo: ["currentTournament": selectedTournament!])
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TournamentsTableViewController.refreshTournaments), name: gStackLoginWithAppIDNotificationName, object: nil)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //prepare data in viewdidload time
        
        
        if gStackCachedTournaments.count == 0 {
            refreshTournaments()
        }
        
        //Refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(TournamentsTableViewController.refreshTournaments), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl!)
        
    }
    

    
    override func viewWillAppear(animated: Bool) {
        
        // Make better for scroll between tables
        if let currentTournament = selectedTournament{
            NSNotificationCenter.defaultCenter().postNotificationName(TournamentWillAppearNotificationName, object: self, userInfo: ["currentTournament": currentTournament])
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(TournamentWillAppearNotificationName, object: self, userInfo: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tournaments.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let height = self.tableView.frame.height * 0.18
        
        return CGFloat(height)
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height = self.tableView.frame.height * 0.02
        return CGFloat(height)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // make the auto focus cell's UI disappear
        if self.isNeedChangeForFirstCell && indexPath.section != 0 {
            let temp = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TournamentTableViewCell
            temp.changeCorlorWhenDeselect()
        }
        self.isNeedChangeForFirstCell = false
        
        //Change UI when select the cell
        self.selectedTournament = tournaments[indexPath.section]
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TournamentTableViewCell
        cell.changeColorWhenSelect()
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TournamentTableViewCell
        cell.changeCorlorWhenDeselect()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && self.isFirstShow {
            let temp = cell as! TournamentTableViewCell
            self.autoFocusOnFirstItem(temp)
            self.isFirstShow = false
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TournamentCell", forIndexPath: indexPath) as! TournamentTableViewCell
        
        // Configure the cell...
        let tournament = tournaments[indexPath.section]
        cell.backgroundColor = UIColor.clearColor()
        cell.myLabel.text = tournament.name
        cell.setRoundCorner()
        cell.setupCellBackground()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    

    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
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
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Refresh Control
    func refreshTournaments() {
        //Load tournaments
        gStackFetchTournaments({
            error, _ in
            if error != nil {
                print("Error fetching tournaments: \(error!)")
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.tournaments = gStackTournament.tournamentsForStatusInArray(self.tournamentStatus, filter: self.tournamentFilter, array: gStackCachedTournaments)
                    self.isFirstShow = true
                    self.isNeedChangeForFirstCell = true
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })
            }
        })
    }
    
    func autoFocusOnFirstItem(cell: TournamentTableViewCell){
        
        if self.tournaments.count > 0 {
            
            self.selectedTournament = tournaments[0]
            
            cell.changeColorWhenSelect()
        }
        
    }
    
    
    
}
