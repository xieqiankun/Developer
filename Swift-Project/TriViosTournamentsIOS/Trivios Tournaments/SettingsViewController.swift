//
//  SettingsViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/11/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit
import StoreKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet var settingLabel: UILabel!
}

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SKStoreProductViewControllerDelegate {

    @IBOutlet var profileView: UIView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var viewProfileButton: UIButton!
    @IBOutlet var settingsTableView: UITableView!
    
    var settings = ["Shop","Promotions","Submit Question","Settings","Play Our Other Games"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if isCurrentUserLoggedIn() {
            configureProfileInformation()
        } else {
            print("USER NOT LOGGED IN")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = settingsTableView.indexPathForSelectedRow {
            settingsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    
    
    func configureProfileInformation() {
        usernameLabel.text = triviaCurrentUser?.displayName
        
        if let fullAvatarString = triviaCurrentUser?.avatar {
            let shortenedAvatarString = fullAvatarString.substringFromIndex(fullAvatarString.startIndex.advancedBy(5))
            avatarImageView.image = UIImage(named: shortenedAvatarString)
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ProfileSegue" {
            let destinationVC = segue.destinationViewController as! ProfileViewController
            if let displayName = triviaCurrentUser?.displayName {
                destinationVC.displayName = displayName
            }
        }
    }
    
    
    
    // MARK: - Table View Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath) as! SettingsTableViewCell
        
        let settingLabel = cell.settingLabel
        
        settingLabel.text = settings[indexPath.row]
        
        return cell
    }
    
    
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let setting = settings[indexPath.row]
        if setting == "Shop" || setting == "Submit Question" || setting == "Promotions" || setting == "Settings" {
            if !isCurrentUserLoggedIn() {
                performSegueWithIdentifier("LoginSegue", sender: nil)
                return
            }
        }
        if setting == "Play Our Other Games" {
            loadAppStorePage()
        } else {
            performSegueWithIdentifier(setting+"-Segue", sender: nil)
        }
    }
    
    
    func loadAppStorePage() {
        let appStoreVC = SKStoreProductViewController()
        appStoreVC.delegate = self
        appStoreVC.loadProductWithParameters([SKStoreProductParameterITunesItemIdentifier: "903967339"], completionBlock: nil)
        presentViewController(appStoreVC, animated: true, completion: nil)
    }
    
    
    //MARK: - SKStoreProductViewControllerDelegate
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        
        if let indexPath = settingsTableView.indexPathForSelectedRow {
            settingsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}
