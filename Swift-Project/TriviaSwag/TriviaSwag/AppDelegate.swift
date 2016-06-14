//
//  AppDelegate.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/4/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit
import CoreData

let MyManagedObjectContextSaveDidFailNotification = "MyManagedObjectContextSaveDidFailNotification"

func fatalCoreDataError(error: ErrorType) {
    print("*** Fatal error: \(error)")
    NSNotificationCenter.defaultCenter().postNotificationName(MyManagedObjectContextSaveDidFailNotification, object: nil)
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        print(NSBundle.mainBundle())
        //TODO - change the message thing
        // preload tournaments
        if let appId = NSUserDefaults.standardUserDefaults().stringForKey(gStackAppIdTokenKey), pusherChannel = NSUserDefaults.standardUserDefaults().stringForKey(gStackPusherChannelKey) {
            gStackAppIDToken = appId//"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhcHBJZCI6MzA4MTg5NTQyLCJpYXQiOjE0NjIyMjk0MzksImV4cCI6MTQ2MjgzNDIzOX0.kaoMIzqFCwUtl5Y8zSZDyDmK1yEe85LIvQ2xUWwkCDs"
            gStackPusherChannel = pusherChannel
            gStackNotificationHandler.sharedInstance.connectToPushServerWithChannel(gStackPusherChannel!)
            gStackFetchTournaments({ (error, tournaments) in
                if error == nil {
                    print("fetch tournamnet without error")
                } else {
                    gStackAppIDToken = nil
                    gStackPusherChannel = nil
                    // Maybe token expire
                    self.fetchTournamentWithAppID()
                    print("refetch the tournament")
                }
            })
            
            triviaUser.logInFromSavedToken { (error) in
                if error != nil {
                    print(triviaCurrentUser)
                    triviaCurrentUser = nil
                }
            }
        } else {
        
            fetchTournamentWithAppID()
            
            triviaUser.logInFromSavedToken { (error) in

            }
        }


        
        //preload shop
        triviaFetchDataCenter({ (center, error) in
            
        })
        //Set up default settings
        if NSUserDefaults.standardUserDefaults().boolForKey("SetupDefaults") == false {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "SetupDefaults")
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "SoundsSetting")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "PushSetting")
            
            NSUserDefaults.standardUserDefaults().synchronize()
        } else {
            
        }
        
               
        //Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Cache
        let URLCache = NSURLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 200 * 1024 * 1024, diskPath: nil)
        NSURLCache.setSharedURLCache(URLCache)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        clearTmpDirectory()
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
    

    func fetchTournamentWithAppID() {
        
        gStackLoginWithAppID() { (error) -> Void in
            
            if error == nil {
                gStackFetchTournaments({ (error, tournaments) in
                    if error != nil {
                        
                    }
                })
            }
        }
    }
    
    
    // MARK: - Cache management
    
    // clear temp files
    
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(NSTemporaryDirectory())
            try tmpDirectory.forEach { file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try NSFileManager.defaultManager().removeItemAtPath(path)
            }
        } catch {
            print(error)
        }
    }

    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "net.purplegator.qiankunxie.jjgjkhg" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        print("xqk")
        print(urls[urls.count-1])
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("ChatMessagesModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}












