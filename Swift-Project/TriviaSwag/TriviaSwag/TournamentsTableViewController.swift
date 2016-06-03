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

class TournamentsTableViewController: UITableViewController, gStackTournamentListProtocol {
    
    struct TableViewCellIdentifiers {
        static let tournamentResultCell = "TournamentResultCell"
        static let nothingFoundCell = "NothingFoundCell"
    }
    
    var tournamentStatus = gStackTournamentStatus.Active
    var tournamentFilter = gStackTournamentFilter.None
    
    var tournaments: [gStackTournament] = [gStackTournament]()
    
    var selectedTournament: gStackTournament?{
        didSet{
            // maintain the concurrency between different views
            // using this if statement aims to control multipe refresh leaderboard when refresh tournaments
            // using a globle var to store current active page and compare the status with the pages
            if tournamentStatus == currentActiveTableStatus {
                NSNotificationCenter.defaultCenter().postNotificationName(TournamentDidSelectNotificationName, object: self, userInfo: ["currentTournament": selectedTournament!])
            }
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TournamentsTableViewController.refreshTournamentsFromCache), name: gStackFetchTournamentsNotificationName, object: nil)
    }
    
    
    func refreshTournamentsFromCache() {
        self.tournaments = gStackTournament.tournamentsForStatusInArray(self.tournamentStatus, filter: self.tournamentFilter, array: gStackCachedTournaments)
        dispatch_async(dispatch_get_main_queue()) { 

            self.tableView.reloadData()
            
            let rowToSelect:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0) //slecting 0th row with 0th section
            self.tableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None)
            self.tableView(self.tableView, didSelectRowAtIndexPath: rowToSelect)
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(TournamentsTableViewController.refreshTournaments), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl!)
        
        var cellNib = UINib(nibName: TableViewCellIdentifiers.tournamentResultCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.tournamentResultCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
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
        
        if tournaments.count == 0 {
            return 1
        }
        return tournaments.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let height = self.tableView.frame.height * 0.2
        
        return CGFloat(height)
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height = self.tableView.frame.height * 0.01
        return CGFloat(height)
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if tournaments.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        //Change UI when select the cell
        self.selectedTournament = tournaments[indexPath.section]
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TournamentTableViewCell
        cell.changeColorWhenSelect()
        print("did select")
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TournamentTableViewCell{
            cell.changeCorlorWhenDeselect()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tournaments.count == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath)
            cell.backgroundColor = UIColor.clearColor()
            // disable selection
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.tournamentResultCell, forIndexPath: indexPath) as! TournamentTableViewCell
            cell.tournamentStatus = self.tournamentStatus
            
            // Configure the cell...
            let tournament = tournaments[indexPath.section]

            cell.setupCell(tournament)
            cell.startbtn.addTarget(self, action: #selector(TournamentsTableViewController.startgame(_:)), forControlEvents: .TouchUpInside)
            
            if tournaments[indexPath.section] == selectedTournament{
                cell.changeColorWhenSelect()
            }
            
            return cell
        }
    }
    
    private var selectedPlayBtn:NSIndexPath?
    func startgame(sender: UIButton) {
        
        let point = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexpath = self.tableView.indexPathForRowAtPoint(point)
        selectedPlayBtn = indexpath
        self.performSegueWithIdentifier("GamePlaySegue", sender: self)
        
        
    }
    
    // MARK: - Refresh Control
    func refreshTournaments() {
        //Load tournaments
        
        if gStackAppIDToken == nil {
            gStackLoginWithAppID() { (error) -> Void in
                gStackFetchTournaments({
                    error, _ in
                    if error != nil {
                        print("Error fetching tournaments: \(error!)")
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.refreshControl?.endRefreshing()
                        })
                    }
                })
            }
        } else {
            gStackFetchTournaments({
                error, _ in
                if error != nil {
                    print("Error fetching tournaments: \(error!)")
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.refreshControl?.endRefreshing()
                    })
                }
            })
        }
    }
    
    func autoFocusOnFirstItem(cell: TournamentTableViewCell){
        
        if self.tournaments.count > 0 {
            
            self.selectedTournament = tournaments[0]
            
            cell.changeColorWhenSelect()
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "GamePlaySegue" {
            
            let vc = segue.destinationViewController as! GameViewController
            if let indexpath = selectedPlayBtn {
                vc.currentTournament = self.tournaments[indexpath.section]
            }
            print("I am in segue \(vc.currentTournament?.name)")
        }
        
    }

}










