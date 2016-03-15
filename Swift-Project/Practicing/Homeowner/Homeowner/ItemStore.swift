//
//  ItemStore.swift
//  Homeowner
//
//  Created by 谢乾坤 on 3/9/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
    //to get the url
    let itemArchiveURL: NSURL = {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("items.archive")
    }()
    
    init(){
        if let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchiveURL.path!) as? [Item] {
            allItems += archivedItems
        }
    }
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    func removeItem(item: Item){
        if let index = allItems.indexOf(item){
            allItems.removeAtIndex(index)
        }
    }
    
    func moveItemAtIndex(fromIndex: Int, toIndex:Int) {
        if fromIndex == toIndex {
            return
        }
        let movedItem = allItems[fromIndex]
        
        allItems.insert(movedItem, atIndex: toIndex)
    }
    
    func saveChanges() -> Bool {
        
        print("Saving items to :\(itemArchiveURL.path!)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path!)
        
    }
    
}
