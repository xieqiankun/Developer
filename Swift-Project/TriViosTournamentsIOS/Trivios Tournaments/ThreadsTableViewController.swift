//
//  ThreadsTableViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/14/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class ThreadTableViewCell: UITableViewCell {
    @IBOutlet var senderLabel: UILabel!
    @IBOutlet var messagePreviewLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    var senderName = ""
}

class ThreadsTableViewController: UITableViewController {
    
    var threads = Dictionary<String,Array<gStackMessage>>()
    var senders = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refreshMessages", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var attemptedLogin = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if isCurrentUserLoggedIn() {
            refreshMessages()
        } else {
            if attemptedLogin == false {
                performSegueWithIdentifier("LoginSegue", sender: nil)
                attemptedLogin = true
            }
            else {
                tabBarController?.selectedIndex = 0
                attemptedLogin = false
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return senders.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ThreadCell", forIndexPath: indexPath) as! ThreadTableViewCell

        // Configure the cell...
        let sender = senders[indexPath.row]
        
        cell.senderLabel.text = sender
        cell.senderName = sender
        
        if let latestMessage = gStackMessage.latestMessageInArray(threads[sender]!) {
            cell.messagePreviewLabel.text = latestMessage.body
            
            var dateString = latestMessage.date!.shortDateString
            if latestMessage.date!.isToday() {
                dateString = latestMessage.date!.shortTimeString
            }
            cell.dateLabel.text = dateString
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "ThreadSelectedSegue" {
            let destinationVc = segue.destinationViewController as! ThreadViewController
            let senderName = (sender as! ThreadTableViewCell).senderName
            destinationVc.messages = threads[senderName]!
            destinationVc.sender = senderName
        }
    }
    

    // MARK: - Refresh
    func refreshMessages() {
        gStackGetCurrentUserInbox({
            error, inbox in
            if error != nil {
                print("Error getting user inbox: \(error!)")
            } else {
                self.threads = inbox!.threads
                self.senders = inbox!.messageSendersByDate()
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        })
    }
    
    
    
    @IBAction func composeMessage() {
        performSegueWithIdentifier("ComposeMessageSegue", sender: nil)
    }
}
