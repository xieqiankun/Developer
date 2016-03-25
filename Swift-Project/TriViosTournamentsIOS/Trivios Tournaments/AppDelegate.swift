//
//  AppDelegate.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 7/28/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var kTriviosTournamentsServerURLPrefix = ""
    
    var window: UIWindow?
 
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        gStackLoginWithAppID("308189542", appKey: "/o3I3goKCQ==") { (error) -> Void in
            
        }
        
        if let path = NSBundle.mainBundle().pathForResource("ServerInfo", ofType: "plist") {
            let dictionary = NSDictionary(contentsOfFile: path)! as! Dictionary<String,String>
            AppDelegate.kTriviosTournamentsServerURLPrefix = dictionary["ServerPrefix"]!
        }
        
        triviaUser.logInFromSavedToken({ error in
            if error != nil {
                print("Could not log in from saved token: \(error!)")
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName("LoggedInUserFromSavedToken", object: nil)
            }
        })
        
        //Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        //Set up default settings
        if NSUserDefaults.standardUserDefaults().boolForKey("SetupDefaults") == false {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "SetupDefaults")
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "SoundsSetting")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "PushSetting")
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }

        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //Facebook
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
}

