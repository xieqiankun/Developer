//
//  ReportQuestionTableViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/25/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class ReportQuestionTableViewController: UITableViewController {
    
    @IBOutlet var okButton: UIBarButtonItem!
    
    var reportReasons = ["Wrong Answer","Wrong Category","Repeated Question","Question Too Specific","Offensive Content","Answer will change in the future","Spam","Send a comment"]
    
    var question: gStackGameQuestion?
    var tournament: gStackTournament?
    
    var shouldPop = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        okButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if shouldPop == true {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return reportReasons.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReasonCell", forIndexPath: indexPath) 

        // Configure the cell...
        cell.textLabel?.text = reportReasons[indexPath.row]

        return cell
    }
    
    
    
    @IBAction func okButtonPressed() {
        if let row = tableView.indexPathForSelectedRow?.row {
            if tournament!.questions!._zone == nil {
                tournament!.questions!._zone = ""
            }
            if tournament!.questions!.category == nil{
                tournament!.questions!.category = ""
            }
            let flaggableQuestion = gStackQuestion(aZone: tournament!.questions!._zone!, _category: tournament!.questions!.category!, _questionBody: question!.question!, _reason: reportReasons[row])
            gStackFlagQuestion(flaggableQuestion, completion: {
                error in
                if error != nil {
                    let alertController = UIAlertController(title: "Error", message: "There was an error: \(error!.domain)", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Success", message: "The question was successfully reported. Thanks!", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "You're Welcome", style: UIAlertActionStyle.Default, handler: { action in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == reportReasons.count - 1 {
            performSegueWithIdentifier("SendFeedback", sender: nil)
        } else {
            okButton.enabled = true
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        okButton.enabled = false
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
        if segue.identifier == "SendFeedback" {
            let destinationVC = segue.destinationViewController as! SendFeedbackViewController
            destinationVC.reportVC = self
            destinationVC.tournament = tournament
            destinationVC.question = question
        }
    }
    

}
