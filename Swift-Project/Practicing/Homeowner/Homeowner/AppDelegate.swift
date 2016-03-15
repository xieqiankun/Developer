//
//  AppDelegate.swift
//  Homeowner
//
//  Created by 谢乾坤 on 3/9/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let itemStore = ItemStore()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //create an ItemStore
        //let itemStore = ItemStore()
        let imageStore = ImageStore()
        
        //let itemsController = window!.rootViewController as! ItemsTableViewController
        let navController = window!.rootViewController as! UINavigationController
        let itemsController = navController.topViewController as! ItemsTableViewController
        itemsController.itemStore = itemStore
        itemsController.imageStore = imageStore
        
        print(__FUNCTION__)
        print(NSBundle.mainBundle().bundlePath)

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        print(__FUNCTION__)
    }

    func applicationDidEnterBackground(application: UIApplication) {
            let success = itemStore.saveChanges()
        
        print(__FUNCTION__)

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print(__FUNCTION__)

    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print(__FUNCTION__)

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print(__FUNCTION__)

    }


}

