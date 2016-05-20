//
//  CoreDataUtlis.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/18/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation
import CoreData

func getManagedObjectContext() -> NSManagedObjectContext {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    return appDelegate.managedObjectContext
}

func saveContext() {
    
    let context = getManagedObjectContext()
    
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }

    
}