//
//  SettingsTableViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/20/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit


protocol SettingCellChangeDelegate {
    func dismissCurrentViewController()
    func showDetailSettingController(name: String)
}

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingImage: UIImageView!
    
    var currentLable: String?
    
    func setIconImage(str: String) {
        settingImage.tintColor = SettingSlaveImageTintColor
        
        if let image = UIImage(named: str+"Icon"){
            settingImage.image = image
        } else {
            settingImage.image = UIImage(named: "GeneralIcon")
        }
    }
    
    func setLabel(str: String){
        currentLable = str
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : SettingSlaveImageTintColor,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : -3.0
        ]

        settingLabel.attributedText = NSAttributedString(string: str, attributes: strokeTextAttributes)
    }
    
    func didSelectCell(){
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : SettingSlaveImageTintColor,
            NSForegroundColorAttributeName : SettingSlaveImageTintColor,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        if let str = currentLable {
            settingLabel.attributedText = NSAttributedString(string: str, attributes: strokeTextAttributes)
        } else {
            settingLabel.attributedText = NSAttributedString(string: "", attributes: strokeTextAttributes)
        }
        
    }
    
    func didDeselectCell(){
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : SettingSlaveImageTintColor,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : -3.0
        ]
        
        if let str = currentLable {
            settingLabel.attributedText = NSAttributedString(string: str, attributes: strokeTextAttributes)
        } else {
            settingLabel.attributedText = NSAttributedString(string: "", attributes: strokeTextAttributes)
        }
        
    }
    
}

class SettingsTableViewController: UITableViewController {
    
    var delegate: SettingCellChangeDelegate?
    
    var settings = ["General", "Account Infomation", "Change Password", "Submit Questions","Tutorials", "Help", "Contact Support", "Rate The App", "Legal Stuff", "Log Out"]
    var segueNames = ["General", "AccountInfomation", "ChangePassword","SubmitQuestions", "Tutorials", "Help", "ContactSupport", "RateTheApp", "LegalStuff", "LogOut"]
    
    var lastIndexPath: NSIndexPath?
    var isFirstInit = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = SettingMasterBackgroundColor
        tableView.separatorColor = SettingMasterSelectedCellColor
        
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFirstInit {
            isFirstInit = false
            // Init the cell for selected one
            //TODO:- A bug here need to fix
            let indexpath = NSIndexPath(forRow: 0,inSection: 0)
            self.tableView.selectRowAtIndexPath(indexpath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            delegate?.showDetailSettingController("General")
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! SettingsTableViewCell
            cell.backgroundColor = SettingMasterSelectedCellColor
            cell.didSelectCell()
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if isCurrentUserLoggedIn() {
            return settings.count
        }
        
        return settings.count - 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingCell", forIndexPath: indexPath) as! SettingsTableViewCell
        
        cell.setLabel(settings[indexPath.row])
        cell.setIconImage(segueNames[indexPath.row])
        
        if lastIndexPath?.row == indexPath.row {
            cell.backgroundColor = SettingMasterSelectedCellColor
            cell.didSelectCell()
        } else {
            cell.backgroundColor = UIColor.clearColor()
        }
        

        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let lastPath = self.lastIndexPath{
            if (indexPath.row != lastPath.row){
                let nextCell = cell as! SettingsTableViewCell
                nextCell.backgroundColor = UIColor.clearColor()
                nextCell.didDeselectCell()
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

        delegate?.dismissCurrentViewController()
        if let pendingCell = tableView.cellForRowAtIndexPath(indexPath){
            let cell = pendingCell as! SettingsTableViewCell
            cell.backgroundColor = UIColor.clearColor()
            cell.didDeselectCell()
        }
      
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == self.lastIndexPath {
            return
        }
        self.lastIndexPath = indexPath
        delegate?.showDetailSettingController(segueNames[indexPath.row])
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SettingsTableViewCell
        cell.backgroundColor = SettingMasterSelectedCellColor
        cell.didSelectCell()
        if (settings[indexPath.row] == "Log Out"){
            triviaUser.logOutCurrentUser()
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        
    }
    


}











