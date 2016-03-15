//
//  ItemsTableViewController.swift
//  Homeowner
//
//  Created by 谢乾坤 on 3/9/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {

    
    var itemStore:ItemStore!
    var imageStore:ImageStore!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.rightBarButtonItem = editButtonItem()
    }
    
    @IBAction func addNewItem(sender: AnyObject) {
        
//        let lastRow = tableView.numberOfRowsInSection(0)
//        let indexPath = NSIndexPath(forRow: lastRow, inSection: 0)
//        
//        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        let newItem = itemStore.createItem()
        
        if let index = itemStore.allItems.indexOf(newItem) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        
        
    }
    
    
    
//    @IBAction func toggleEditingMode(sender: AnyObject) {
//        
//        if editing {
//            
//            sender.setTitle("Edit", forState: .Normal)
//            setEditing(false, animated: true)
//        }
//        else {
//            sender.setTitle("Done", forState: .Normal)
//            setEditing(true, animated: true)
//        }
//    }

  
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
//        
//        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
//        tableView.contentInset = insets
//        tableView.scrollIndicatorInsets = insets
//        
        //tableView.rowHeight = 65
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return itemStore.allItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .Value1, reuseIdentifier: "UITableViewCell")
        //let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        //update font for cells
        cell.updateLabels()
        
        let item = itemStore.allItems[indexPath.row]
        
        //cell.textLabel?.text = item.name
        //cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
        
        return cell
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {

            let item = itemStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)"
            let message = "Are you sure"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
                self.itemStore.removeItem(item)
                
                //delete in imageStore
                self.imageStore.deleteImageForKey(item.itemKey)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                
            })
            
            ac.addAction(deleteAction)
            
            //present the alert controller
            presentViewController(ac, animated: true, completion: nil)

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        //update model
        itemStore.moveItemAtIndex(fromIndexPath.row, toIndex: toIndexPath.row)
        
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //if the segue is the "showItem" segue
        if segue.identifier == "ShowItem" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = itemStore.allItems[row]
                let detailViewController = segue.destinationViewController as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        }

    }

}
