//
//  LoginViewController.swift
//  GStack-Swift-SDK
//
//  Created by 谢乾坤 on 3/7/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var appId: UITextField!
    
    @IBOutlet weak var aooKey: UITextField!
    
    @IBOutlet weak var username: UITextField!
    
    @IBAction func login(sender: UIButton) {
        
        let usernameField = "308189542"
        let passwordField = "/o3I3goKCQ=="
        
        GStack.sharedInstance.gStackLoginWithAppID(usernameField, appKey: passwordField) { (error) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                //go to first tab view controller
                let appDeldegateTemp = UIApplication.sharedApplication().delegate as! AppDelegate
                
                let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                
                let vc = storyboard.instantiateInitialViewController()
                
                appDeldegateTemp.window?.rootViewController = vc
                
            })
            
        }
        
        
        
    }

}
