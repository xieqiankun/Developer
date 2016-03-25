//
//  ChangePasswordTableViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/26/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class ChangePasswordTableViewCell: UITableViewCell {
    @IBOutlet var passwordTextField: TextFieldValidator?
    @IBOutlet var actionButton: UIButton?
}

class ChangePasswordTableViewController: UITableViewController, UITextFieldDelegate {
    
    var REGEX_PASSWORD_LENGTH = "^.{6,24}$"
    var REGEX_PASSWORD = "([-@./#&+\\w]){6,24}"
    
    var newPasswordTextField: TextFieldValidator?

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
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if section == 2 {
            return 2
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Change or Recover Your Password"
        }
        return nil
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = "PasswordCell"
        if indexPath.section == 1 || indexPath.section == 3 {
            identifier = "ButtonCell"
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ChangePasswordTableViewCell

        // Configure the cell...
        cell.passwordTextField?.delegate = self
        cell.passwordTextField?.presentInView = view
        cell.selectionStyle = .None
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            cell.passwordTextField?.placeholder = "Current Password"
        case (1,0):
            cell.actionButton?.setTitle("Forgot Your Password?", forState: UIControlState.Normal)
            cell.actionButton?.addTarget(self, action: "forgotPassword", forControlEvents: UIControlEvents.TouchUpInside)
        case (2,0):
            cell.passwordTextField?.placeholder = "New Password"
            cell.passwordTextField?.addRegx(REGEX_PASSWORD_LENGTH, withMsg: "Password must be between 6 and 24 characters long")
            cell.passwordTextField?.addRegx(REGEX_PASSWORD, withMsg: "Invalid password")
            newPasswordTextField = cell.passwordTextField
        case (2,1):
            cell.passwordTextField?.placeholder = "Verify Password"
            if newPasswordTextField != nil {
                cell.passwordTextField?.addConfirmValidationTo(newPasswordTextField!, withMsg: "Passwords must match")
            }
            cell.passwordTextField?.returnKeyType = UIReturnKeyType.Done
        case (3,0):
            cell.actionButton?.setTitle("Save Changes", forState: UIControlState.Normal)
            cell.actionButton?.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        default:
            break
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func save() {
        let currentPasswordTextField = (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ChangePasswordTableViewCell).passwordTextField!
        let newPasswordTextField = (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as! ChangePasswordTableViewCell).passwordTextField!
        let verifyPasswordTextField = (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 2)) as! ChangePasswordTableViewCell).passwordTextField!
        
        view.endEditing(true)
        
        if currentPasswordTextField.text!.characters.count > 0 && newPasswordTextField.validate() && verifyPasswordTextField.validate() {
            triviaChangeUserPassword(currentPasswordTextField.text!, newPassword: newPasswordTextField.text!, completion: {
                error in
                if error != nil {
                    let alertController = UIAlertController(title: "Error", message: "There was an error: \(error!.domain)", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Success", message: "Your password was changed successfully", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                        dispatch_async(dispatch_get_main_queue(), {
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    })
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            })
        } else {
            let alertController = UIAlertController(title: "Uh Oh", message: "One ore more of the input fields are invalid", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    //Just Kidding
    func forgotPassword() {
        let alertController = UIAlertController(title: "U dummy", message: "y u forget?", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "cuz i dumb", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - TextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        tableView.scrollToRowAtIndexPath(tableView.indexPathForCell(textField.superview!.superview as! UITableViewCell)!, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let indexPath = tableView.indexPathForCell(textField.superview!.superview as! UITableViewCell)
        switch (indexPath!.section,indexPath!.row) {
        case (0,0):
            textField.resignFirstResponder()
            let nextCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as! ChangePasswordTableViewCell
            nextCell.passwordTextField!.becomeFirstResponder()
        case (2,0):
            textField.resignFirstResponder()
            let nextCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 2)) as! ChangePasswordTableViewCell
            nextCell.passwordTextField!.becomeFirstResponder()
        case (2,1):
            save()
        default:
            break
        }
        return true
    }
}
