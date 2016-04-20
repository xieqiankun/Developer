//
//  AppDelegate.swift
//  MyLocations
//
//  Created by 谢乾坤 on 4/15/16.
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
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        //The Core Data model you created earlier is stored in your application bundle in a folder named “DataModel.momd”. Here you create an NSURL object pointing at this folder in the app bundle. Paths to files and folders are often represented by URLs in the iOS frameworks.
        guard let modelURL = NSBundle.mainBundle().URLForResource("DataModel", withExtension: "momd")
            else {
                fatalError("Could not find data model in app bundle")
        }
        //Create an NSManagedObjectModel from that URL. This object represents the data model during runtime. You can ask it what sort of entities it has, what attributes these entities have, and so on. In most apps you don’t need to use the NSManagedObjectModel object directly.
        guard let model = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing model from: \(modelURL)")
        }
        
        //The app’s data is stored in an SQLite database inside the app’s Documents folder. Here you create an NSURL object pointing at the DataStore.sqlite file.
        let urls = NSFileManager.defaultManager().URLsForDirectory( .DocumentDirectory,
                                                                    inDomains: .UserDomainMask)
        let documentsDirectory = urls[0]
        let storeURL = documentsDirectory.URLByAppendingPathComponent("DataStore.sqlite")
        //print(storeURL)
        
        do {
            //Create an NSPersistentStoreCoordinator object. This object is in charge of the SQLite database.
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            
            //Add the SQLite database to the store coordinator.
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            
            //Finally, create the NSManagedObjectContext object and return it.
            let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            return context
            
            // If something went wrong with the above, print an error message and terminate the app. In theory, errors should never happen here but you definitely want to have an error message in place to help with debugging. Just in case.
        } catch {
            fatalError("Error adding persistent store at \(storeURL): \(error)") }
    }()
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        let tabBarController = window!.rootViewController as! UITabBarController
        
        if let tabBarViewControllers = tabBarController.viewControllers {
            let currentLocationViewController = tabBarViewControllers[0] as! CurrentLoactionViewController
            currentLocationViewController.managedObjectContext = managedObjectContext
            
            let navigationController = tabBarViewControllers[1]
                as! UINavigationController
            let locationsViewController = navigationController.viewControllers[0] as! LocationsViewController
            locationsViewController.managedObjectContext = managedObjectContext
            
            // to fix the bug:
            //CoreData: FATAL ERROR: The persistent cache of section information does not match the current configuration. You have illegally mutated the NSFetchedResultsController's fetch request, its predicate, or its sort descriptor without either disabling caching or using +deleteCacheWithName:
            let _ = locationsViewController.view
            
            let mapViewController = tabBarViewControllers[2] as! MapViewController
            mapViewController.managedObjectContext = managedObjectContext

        }
        
        listenForFatalCoreDataNotifications()
        
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
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func listenForFatalCoreDataNotifications() {
        
        // 1 Tell NSNotificationCenter that you want to be notified whenever a MyManagedObjectContextSaveDidFailNotification is posted. The actual code that is performed when that happens sits in a closure following usingBlock:. (“Block” is the term that Objective-C uses for a closure.)
        NSNotificationCenter.defaultCenter().addObserverForName( MyManagedObjectContextSaveDidFailNotification, object: nil, queue: NSOperationQueue.mainQueue(),usingBlock: { notification in

            // 2  Create a UIAlertController to show the error message.
            let alert = UIAlertController(title: "Internal Error", message: "There was a fatal error in the app and it cannot continue.\n\n" + "Press OK to terminate the app. Sorry for the inconvenience.", preferredStyle: .Alert)
            
            // 3 Add an action for the alert’s OK button. The code for handling the button press is again a closure (these things are everywhere!). Instead of calling fatalError(), the closure creates an NSException object to terminate the app. That’s a bit nicer and it provides more information to the crash log.
            let action = UIAlertAction(title: "OK", style: .Default) { _ in
                let exception = NSException(name: NSInternalInconsistencyException,reason: "Fatal Core Data error", userInfo: nil)
                exception.raise()
            }
            alert.addAction(action)
            
            // 4 Finally, you present the alert.
            self.viewControllerForShowingAlert().presentViewController( alert, animated: true, completion: nil)
        })
    }
    // 5  To show the alert with presentViewController(animated, completion) you need a view controller that is currently visible, so this helper method finds one that is. Unfortunately you can’t simply use the window’s rootViewController – in this app that is the tab bar controller – because it will be hidden when the Location Details screen is open
    func viewControllerForShowingAlert() -> UIViewController {
        let rootViewController = self.window!.rootViewController!
        if let presentedViewController = rootViewController.presentedViewController {
            return presentedViewController
        } else {
            return rootViewController
        }
    }
    
    
    
    
}

