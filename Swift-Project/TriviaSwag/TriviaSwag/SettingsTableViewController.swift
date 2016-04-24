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
    
    
}

class SettingsTableViewController: UITableViewController {
    
    var delegate: SettingCellChangeDelegate?
    
    var settings = ["General", "Account Infomation", "Change Password", "Tutorials", "Help", "Contact Support", "Rate The App", "Legal Stuff", "Log Out"]
    var segueNames = ["General", "AccountInfomation", "ChangePassword", "Tutorials", "Help", "ContactSupport", "RateTheApp", "LegalStuff", "LogOut"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let indexpath = NSIndexPath(forRow: 0,inSection: 0)
        self.tableView.selectRowAtIndexPath(indexpath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        delegate?.showDetailSettingController("General")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        cell.settingLabel.text = settings[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.dismissCurrentViewController()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.showDetailSettingController(segueNames[indexPath.row])
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

}
