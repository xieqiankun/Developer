//
//  SettingsViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/20/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var settingsTableController: SettingsTableViewController!
    var settingDetailController: SettingDetailViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // init the view
        settingsTableController.delegate = settingDetailController
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backToMain(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let embeddedViewController = segue.destinationViewController as? SettingsTableViewController where segue.identifier == "EmbededSettingTableSegue" {
            self.settingsTableController = embeddedViewController
            
        } else if let embeddedViewController = segue.destinationViewController as? UINavigationController where segue.identifier == "EmbededSettingDetailView" {
            let vc = embeddedViewController.topViewController as! SettingDetailViewController
            self.settingDetailController = vc
        }
        
    }

}
