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
    
    //for display logic control
    var isFirstShow = false
    var isNeedChangeForFirstCell = false
    
    var selectedTournament: gStackTournament?{
        didSet{
            // maintain the concurrency between different views
            NSNotificationCenter.defaultCenter().postNotificationName(TournamentDidSelectNotificationName, object: self, userInfo: ["currentTournament": selectedTournament!])
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TournamentsTableViewController.refreshTournaments), name: gStackLoginWithAppIDNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TournamentsTableViewController.refreshTournamentsFromCache), name: gStackFetchTournamentsNotificationName, object: nil)
    }
    
    
    func refreshTournamentsFromCache() {
        self.tournaments = gStackTournament.tournamentsForStatusInArray(self.tournamentStatus, filter: self.tournamentFilter, array: gStackCachedTournaments)
        dispatch_async(dispatch_get_main_queue()) { 
            self.isFirstShow = true
            self.isNeedChangeForFirstCell = true
            self.tableView.reloadData()
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        //prepare data in viewdidload time
//        if gStackCachedTournaments.count == 0 {
//            refreshTournaments()
//        }
        
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
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if tournaments.count == 0 {
            return nil
        } else {
            return indexPath
        }
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
        if indexPath.section == 0 && tournaments.count != 0 && self.isFirstShow {
            let temp = cell as! TournamentTableViewCell
            self.autoFocusOnFirstItem(temp)
            self.isFirstShow = false
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
            
            // Configure the cell...
            let tournament = tournaments[indexPath.section]
            cell.backgroundColor = UIColor.clearColor()
            cell.myLabel.text = tournament.name
            cell.setRoundCorner()
            cell.setupCellBackground()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell
        }
    }
    
    // MARK: - Refresh Control
    func refreshTournaments() {
        //Load tournaments
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
    
    func autoFocusOnFirstItem(cell: TournamentTableViewCell){
        
        if self.tournaments.count > 0 {
            
            self.selectedTournament = tournaments[0]
            
            cell.changeColorWhenSelect()
        }
        
    }

}
