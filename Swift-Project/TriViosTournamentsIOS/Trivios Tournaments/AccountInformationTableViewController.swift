//
//  AccountInformationTableViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/25/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class AccountInformationTableViewCell: UITableViewCell {
    @IBOutlet var inputTextField: UITextField?
}

class AccountInformationTableViewController: UITableViewController, UITextFieldDelegate {
    
    var fields = ["Full Name","Address Line 1","Address Line 2","City","State/Province/Region","ZIP","Country","Phone Number"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if section == 0 {
            return fields.count
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Address Required To Receive Prizes"
        } else {
            return nil
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = "AccountInfoCell"
        if indexPath.section == 1 {
            identifier = "SaveCell"
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! AccountInformationTableViewCell

        // Configure the cell...
        cell.inputTextField?.delegate = self
        cell.inputTextField?.placeholder = fields[indexPath.row]
        cell.selectionStyle = .None
        
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            cell.inputTextField?.text = triviaCurrentUser?.name
        case (0,1):
            cell.inputTextField?.text = triviaCurrentUser?.address?.line1
        case (0,2):
            cell.inputTextField?.text = triviaCurrentUser?.address?.line2
        case (0,3):
            cell.inputTextField?.text = triviaCurrentUser?.address?.city
        case (0,4):
            cell.inputTextField?.text = triviaCurrentUser?.address?.territory
        case (0,5):
            cell.inputTextField?.text = triviaCurrentUser?.address?.zipCode
        case (0,6):
            cell.inputTextField?.text = triviaCurrentUser?.address?.country
        case (0,7):
            cell.inputTextField?.text = triviaCurrentUser?.phone
            cell.inputTextField?.returnKeyType = UIReturnKeyType.Done
        default:
            break
        }

        return cell
    }
    
    
    @IBAction func save() {
        var textFields = Array<UITextField>()
        for idx in 0...fields.count-1 {
            let indexPath = NSIndexPath(forRow: idx, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! AccountInformationTableViewCell
            textFields.append(cell.inputTextField!)
        }
        
        view.endEditing(true)
        
        triviaUpdateAddress(textFields[0].text, phone: textFields[7].text!, address: triviaUserAddress(_line1: textFields[1].text, _line2: textFields[2].text, _city: textFields[3].text, _zipCode: textFields[5].text, _territory: textFields[4].text, _country: textFields[6].text), completion: {
            error in
            dispatch_async(dispatch_get_main_queue(), {
                if error != nil {
                    let alertController = UIAlertController(title: "Error", message: "There was an error: \(error!.domain)", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Success", message: "Your information was saved successfully", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            })
        })
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    
    
    // MARK: - TextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        tableView.scrollToRowAtIndexPath(tableView.indexPathForCell(textField.superview!.superview as! UITableViewCell)!, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let indexPath = tableView.indexPathForCell(textField.superview!.superview as! UITableViewCell)
        if indexPath!.row == fields.count-1 {
            save()
        } else {
            textField.resignFirstResponder()
            let nextCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath!.row+1, inSection: indexPath!.section)) as! AccountInformationTableViewCell
            nextCell.inputTextField!.becomeFirstResponder()
        }
        return true
    }
}
