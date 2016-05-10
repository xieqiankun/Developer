//
//  ChangePasswordTableViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/29/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class ChangePasswordTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oldPassword.delegate = self
        newPassword.delegate = self
        confirmPassword.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    func isValidPassword(testStr: String) -> Bool {
        let regex = "([-@./#&+\\w]){6,24}"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluateWithObject(testStr)
    }
    
    func isValidForSubmit() {
        
        if oldPassword.text?.characters.count > 0 && newPassword.text?.characters.count > 0 && confirmPassword.text?.characters.count > 0 {
            
        }
    }
    
    func showWrongPasswordFormatAlert() {
        
        let alert = UIAlertController(title: "Error", message: "Wrong password format", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
       print("I am here")
        if textField === oldPassword {
            print("1")
            if !isValidPassword(textField.text!){
                showWrongPasswordFormatAlert()
                oldPassword.text = ""
                return false
            }
            textField.resignFirstResponder()
            newPassword.becomeFirstResponder()
        } else if textField === newPassword {
            if !isValidPassword(textField.text!){
                showWrongPasswordFormatAlert()
                newPassword.text = ""
                return false
            }
            textField.resignFirstResponder()
            confirmPassword.becomeFirstResponder()
        } else if textField == confirmPassword {
            
            if !isValidPassword(textField.text!) && confirmPassword.text != newPassword.text{
                showWrongPasswordFormatAlert()
                confirmPassword.text = ""
                return false
            }

            textField.resignFirstResponder()
        }
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        if oldPassword.isFirstResponder() && touch!.view != oldPassword {
            oldPassword.resignFirstResponder()
            if !isValidPassword(oldPassword.text!){
                showWrongPasswordFormatAlert()
            } else {
                isValidForSubmit()
            }
        }
        else if newPassword.isFirstResponder() && touch!.view != newPassword {
            newPassword.resignFirstResponder()
            if !isValidPassword(newPassword.text!){
                showWrongPasswordFormatAlert()
            } else {
                isValidForSubmit()
            }
        }
        else if confirmPassword.isFirstResponder() && touch?.view != confirmPassword {
            confirmPassword.resignFirstResponder()
            if !isValidPassword(confirmPassword.text!){
                showWrongPasswordFormatAlert()
            } else {
                isValidForSubmit()
            }
        }
        
        super.touchesBegan(touches, withEvent: event)
    }

    
    
    
    @IBAction func submit() {
        
            triviaChangeUserPassword(oldPassword.text!, newPassword: newPassword.text!, completion: {
                error in
                if error != nil {
                    let alertController = UIAlertController(title: "Error", message: "There was an error: \(error!.domain)", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(alertController, animated: true, completion: nil)
                        self.oldPassword.text = ""
                    })
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
        }
        
    
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // TODO: - Change the color to background color
        view.tintColor = SettingSlaveTintColor
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Change the color of all cells
        cell.backgroundColor = SettingSlaveCellColor
    }
}

    













