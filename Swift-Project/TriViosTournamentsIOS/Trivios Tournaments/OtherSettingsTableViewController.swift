//
//  OtherSettingsTableViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/25/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class OtherSettingsTableViewCell: UITableViewCell {
    enum CellType {
        case ActionCell
        case SwitchCell
        case InfoCell
        case LogOutCell
    }
    
    var cellType: CellType?
    var indexPath: NSIndexPath?
    
    @IBOutlet var settingNameLabel: UILabel?
    @IBOutlet var settingSwitch: UISwitch?
    @IBOutlet var informationLabel: UILabel?
    
    @IBAction func switchFlipped(sender: UISwitch) {
        if indexPath?.section == 1 && indexPath?.row == 0 {
            NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "SoundsSetting")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        else if indexPath?.section == 1 && indexPath?.row == 1 {
            NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "PushSetting")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}

class OtherSettingsTableViewController: UITableViewController {

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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        switch section {
        case 0:
            return 4
        case 1:
            return 4
        case 2:
            return 6
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Account"
        case 1:
            return "General"
        case 2:
            return "About"
        default:
            return ""
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellType = OtherSettingsTableViewCell.CellType.ActionCell
        var cellIdentifier = "ActionCell"
        if indexPath.section == 1 {
            if indexPath.row == 0 || indexPath.row == 1 {
                cellIdentifier = "SwitchCell"
                cellType = .SwitchCell
            }
        }
        if indexPath.section == 2 && indexPath.row == 0 {
            cellIdentifier = "InfoCell"
            cellType = .InfoCell
        }
        if indexPath.section == 2 && indexPath.row == 5 {
            cellIdentifier = "LogOutCell"
            cellType = .LogOutCell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! OtherSettingsTableViewCell
        
        // Configure the cell...
        cell.cellType = cellType
        cell.indexPath = indexPath
        
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            cell.settingNameLabel?.text = "Account Information"
        case (0,1):
            cell.settingNameLabel?.text = "Change Password"
        case (0,2):
            if triviaCurrentUser == nil || triviaCurrentUser?.isVerified == false {
                cell.settingNameLabel?.text = "Resend Email Verification"
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.selectionStyle = .Default
            } else {
                cell.settingNameLabel?.text = "Email Verified"
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                cell.selectionStyle = .None
            }
        case (0,3):
            if triviaCurrentUser == nil || triviaCurrentUser?.isFacebookLinked == false {
                cell.settingNameLabel?.text = "Connect to Facebook"
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            } else {
                cell.settingNameLabel?.text = "Connected to Facebook"
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        case (1,0):
            cell.settingNameLabel?.text = "Sounds"
            cell.settingSwitch?.on = NSUserDefaults.standardUserDefaults().boolForKey("SoundsSetting")
            cell.selectionStyle = .None
        case (1,1):
            cell.settingNameLabel?.text = "Push Notifications"
            cell.settingSwitch?.on = NSUserDefaults.standardUserDefaults().boolForKey("PushSetting")
            cell.selectionStyle = .None
        case (1,2):
            cell.settingNameLabel?.text = "Contact Support"
        case (1,3):
            cell.settingNameLabel?.text = "Rate the app"
        case (2,0):
            cell.settingNameLabel?.text = "Version"
            cell.informationLabel?.text = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String
            cell.selectionStyle = .None
        case (2,1):
            cell.settingNameLabel?.text = "Tutorials"
        case (2,2):
            cell.settingNameLabel?.text = "FAQs"
        case (2,3):
            cell.settingNameLabel?.text = "Privacy Policy"
        case (2,4):
            cell.settingNameLabel?.text = "Terms of Service"
        case (2,5):
            cell.selectionStyle = .None
        default:
            break
        }
        
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            performSegueWithIdentifier("AccountInfo", sender: nil)
        case (0,1):
            performSegueWithIdentifier("ChangePassword", sender: nil)
        case (0,2):
            resendVerificationEmail()
        case (0,3):
            connectToFacebook()
        case (1,2):
            contactSupport()
        case (2,2):
            performSegueWithIdentifier("WebPage", sender: indexPath)
        case (2,3):
            performSegueWithIdentifier("WebPage", sender: indexPath)
        case (2,4):
            performSegueWithIdentifier("WebPage", sender: indexPath)
        default:
            break
        }
    }
    
    
    func resendVerificationEmail() {
        triviaResendVerificationEmail({
            error in
            dispatch_async(dispatch_get_main_queue(), {
                if error != nil {
                    let alert = UIAlertController(title: "There was a Problem", message: "There was an error! \(error?.description)", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Success", message: "The verification email was sent. Check your email!", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    if let selectedRowIP = self.tableView.indexPathForSelectedRow {
                        self.tableView.deselectRowAtIndexPath(selectedRowIP, animated: true)
                    }
                }
            })
        })
    }
    
    
    //This is a huge gross function
    func connectToFacebook() {
        if FBSDKAccessToken.currentAccessToken() != nil {
            //User has already granted facebook access
            requestFacebookUserInformation({
                error in
                if error != nil {
                    //Error getting facebook user information
                    dispatch_async(dispatch_get_main_queue(), {
                        let alert = UIAlertController(title: "There was a Problem", message: "There was an error getting Facebook information! \(error?.description)", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: { action in
                            dispatch_async(dispatch_get_main_queue(), {
                                if let selectedRowIP = self.tableView.indexPathForSelectedRow {
                                    self.tableView.deselectRowAtIndexPath(selectedRowIP, animated: true)
                                }
                            })
                        })
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                } else {
                    //Success getting facebook user information
                    var name = globalSavedFacebookUser["name"] as? String
                    var gender = globalSavedFacebookUser["gender"] as? String
                    var age_range = globalSavedFacebookUser["age_range"] as? Dictionary<String,AnyObject>
                    var id = globalSavedFacebookUser["id"] as? String
                    var email = globalSavedFacebookUser["email"] as? String
                    if name == nil {
                        name = ""
                    }
                    if gender == nil {
                        gender = ""
                    }
                    if id == nil {
                        id = ""
                    }
                    if email == nil {
                        email = ""
                    }
                    if age_range == nil {
                        age_range = Dictionary<String,AnyObject>()
                    }
                    gStackLinkCurrentUserToFacebook(FBSDKAccessToken.currentAccessToken().tokenString, facebookName: name!, facebookGender: gender!, facebookAgeRange: age_range!, facebookId: id!, facebookEmail: email!, completion: {
                        error in
                        if error != nil{
                            //Success!
                            dispatch_async(dispatch_get_main_queue(), {
                                let alert = UIAlertController(title: "Success", message: "Your account was successfully linked to Facebook", preferredStyle: .Alert)
                                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: { action in
                                    dispatch_async(dispatch_get_main_queue(), {
                                        if let selectedRowIP = self.tableView.indexPathForSelectedRow {
                                            self.tableView.deselectRowAtIndexPath(selectedRowIP, animated: true)
                                        }
                                        triviaCurrentUser?.isFacebookLinked = true
                                        self.tableView.reloadData()
                                    })
                                })
                                alert.addAction(okAction)
                                self.presentViewController(alert, animated: true, completion: nil)
                            })
                        } else {
                            //Error getting facebook user information
                            dispatch_async(dispatch_get_main_queue(), {
                                let alert = UIAlertController(title: "There was a Problem", message: "There was an error linking your account to Facebook! \(error?.description)", preferredStyle: .Alert)
                                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: { action in
                                    dispatch_async(dispatch_get_main_queue(), {
                                        if let selectedRowIP = self.tableView.indexPathForSelectedRow {
                                            self.tableView.deselectRowAtIndexPath(selectedRowIP, animated: true)
                                        }
                                    })
                                })
                                alert.addAction(okAction)
                                self.presentViewController(alert, animated: true, completion: nil)
                            })
                        }
                    })
                }
            })
        } else {
            //User has not granted Facebook access
            let loginManager = FBSDKLoginManager()
            loginManager.logInWithReadPermissions(["public_profile","email","user_friends"], handler: {
                result, error in
                if error != nil {
                    //There was a Facebook error
                    dispatch_async(dispatch_get_main_queue(), {
                        let alert = UIAlertController(title: "There was a Problem", message: "There was an error! \(error?.description)", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: { action in
                            dispatch_async(dispatch_get_main_queue(), {
                                if let selectedRowIP = self.tableView.indexPathForSelectedRow {
                                    self.tableView.deselectRowAtIndexPath(selectedRowIP, animated: true)
                                }
                            })
                        })
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                } else if result.isCancelled == true {
                    //User cancelled the login
                    dispatch_async(dispatch_get_main_queue(), {
                        let alert = UIAlertController(title: "Cancelled Login", message: "You cancelled the login through Facebook.", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: { action in
                            dispatch_async(dispatch_get_main_queue(), {
                                if let selectedRowIP = self.tableView.indexPathForSelectedRow {
                                    self.tableView.deselectRowAtIndexPath(selectedRowIP, animated: true)
                                }
                            })
                        })
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                } else {
                    //User has logged in via Facebook (should we check result.grantedPermissions? Are we asking for anything that can be denied? Should we check later?
                    requestFacebookUserInformation({
                        error2 in
                        if error2 != nil {
                            //There was an error getting user data from Facebook
                            dispatch_async(dispatch_get_main_queue(), {
                                let alert = UIAlertController(title: "There was a Problem", message: "There was an error! \(error2?.description)", preferredStyle: .Alert)
                                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: { action in
                                    dispatch_async(dispatch_get_main_queue(), {
                                        if let selectedRowIP = self.tableView.indexPathForSelectedRow {
                                            self.tableView.deselectRowAtIndexPath(selectedRowIP, animated: true)
                                        }
                                    })
                                })
                                alert.addAction(okAction)
                                self.presentViewController(alert, animated: true, completion: nil)
                            })
                        } else {
                            //Successfully got Facebook information (this code is copy/pasted from above)
                            var name = globalSavedFacebookUser["name"] as? String
                            var gender = globalSavedFacebookUser["gender"] as? String
                            var age_range = globalSavedFacebookUser["age_range"] as? Dictionary<String,AnyObject>
                            var id = globalSavedFacebookUser["id"] as? String
                            var email = globalSavedFacebookUser["email"] as? String
                            if name == nil {
                                name = ""
                            }
                            if gender == nil {
                                gender = ""
                            }
                            if id == nil {
                                id = ""
                            }
                            if email == nil {
                                email = ""
                            }
                            if age_range == nil {
                                age_range = Dictionary<String,AnyObject>()
                            }
                            gStackLinkCurrentUserToFacebook(FBSDKAccessToken.currentAccessToken().tokenString, facebookName: name!, facebookGender: gender!, facebookAgeRange: age_range!, facebookId: id!, facebookEmail: email!, completion: {
                                error in
                                if error != nil{
                                    //Success!
                                    dispatch_async(dispatch_get_main_queue(), {
                                        let alert = UIAlertController(title: "Success", message: "Your account was successfully linked to Facebook", preferredStyle: .Alert)
                                        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: { action in
                                            dispatch_async(dispatch_get_main_queue(), {
                                                if let selectedRowIP = self.tableView.indexPathForSelectedRow {
                                                    self.tableView.deselectRowAtIndexPath(selectedRowIP, animated: true)
                                                }
                                                triviaCurrentUser?.isFacebookLinked = true
                                                self.tableView.reloadData()
                                            })
                                        })
                                        alert.addAction(okAction)
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    })
                                } else {
                                    //Error getting facebook user information
                                    dispatch_async(dispatch_get_main_queue(), {
                                        let alert = UIAlertController(title: "There was a Problem", message: "There was an error linking your account to Facebook! \(error?.description)", preferredStyle: .Alert)
                                        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: { action in
                                            dispatch_async(dispatch_get_main_queue(), {
                                                if let selectedRowIP = self.tableView.indexPathForSelectedRow {
                                                    self.tableView.deselectRowAtIndexPath(selectedRowIP, animated: true)
                                                }
                                            })
                                        })
                                        alert.addAction(okAction)
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    })
                                }
                            })
                        }
                    })
                }
            })
        }
    }
    
    
    func contactSupport() {
        //Email or API?
    }
    
    
    @IBAction func logOut() {
        triviaUser.logOutCurrentUser()
        NSUserDefaults.standardUserDefaults().setObject("", forKey: triviaUserLogInTokenKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let alert = UIAlertController(title: "Success", message: "You were successfully logged out", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Ok", style: .Default, handler: { action in
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        })
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
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
        if segue.identifier == "WebPage" {
            let indexPath = sender as! NSIndexPath
            let destination = segue.destinationViewController as! EmbeddedWebPageViewController
            if indexPath.row == 2 {
                destination.url = NSURL(string: "http://trivios.net/support/")
                destination.navigationItem.title = "FAQs"
            }
            else if indexPath.row == 3 {
                destination.url = NSURL(string: "https://purplegator.net/privacy/")
                destination.navigationItem.title = "Privacy Policy"
            }
            else if indexPath.row == 4 {
                destination.url = NSURL(string: "https://purplegator.net/tos/")
                destination.navigationItem.title = "Terms of Service"
            }
        }
    }
    

}
