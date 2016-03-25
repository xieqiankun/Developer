//
//  LoginUsernameViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/12/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class LoginUsernameViewController: UIViewController, UITextFieldDelegate {
    
    var emailAddress = ""
    var fbToken = ""
    var fbData: [NSObject: AnyObject]?

    @IBOutlet var usernameTextField: TextFieldValidator!
    @IBOutlet var passwordTextField: TextFieldValidator!
    @IBOutlet var referralTextField: UITextField!
    @IBOutlet var submitButton: UIBarButtonItem!
    
    var REGEX_USERNAME_LENGTH = "^.{4,11}$"
    var REGEX_USERNAME = "[A-Za-z0-9]{4,11}"
    var REGEX_PASSWORD_LENGTH = "^.{6,24}$"
    var REGEX_PASSWORD = "([-@./#&+\\w]){6,24}"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Setup textfield validation
        usernameTextField.addRegx(REGEX_USERNAME_LENGTH, withMsg: "Username must be between 4 and 11 characters long")
        usernameTextField.addRegx(REGEX_USERNAME, withMsg: "Username must contain alphanumeric characters only")
        usernameTextField.presentInView = view
        
        passwordTextField.addRegx(REGEX_PASSWORD_LENGTH, withMsg: "Password must be between 6 and 24 characters long")
        passwordTextField.addRegx(REGEX_PASSWORD, withMsg: "Invalid password")
        passwordTextField.presentInView = view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submit() {
        let avatar = resourceNameForRandomAvatar()
        
        if fbToken != "" || fbData != nil {
            triviaFacebookSignUp(usernameTextField.text!, email: emailAddress, password: passwordTextField.text!, avatar: avatar, deviceId: UIDevice.currentDevice().identifierForVendor!.UUIDString, referralCode: referralTextField.text, fbToken: fbToken, fbData: fbData, completion: {
                error in
                dispatch_async(dispatch_get_main_queue(), {
                    if error != nil {
                        let alert = UIAlertController(title: "There was a Problem", message: "There was an error! \(error!.domain)", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Sign Up Successful", message: "Welcome to Trivios Tournaments!", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "Start Playing", style: .Cancel, handler: {
                            completed in
                            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                        })
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
            })
        } else {
            triviaSignUp(usernameTextField.text!, email: emailAddress, password: passwordTextField.text!, avatar: avatar, deviceId: UIDevice.currentDevice().identifierForVendor!.UUIDString, referralCode: referralTextField.text, completion: {
                error in
                dispatch_async(dispatch_get_main_queue(), {
                    if error != nil {
                        let alert = UIAlertController(title: "There was a Problem", message: "There was an error! \(error!.domain)", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Sign Up Successful", message: "Welcome to Trivios Tournaments!", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "Start Playing", style: .Cancel, handler: {
                            completed in
                            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                        })
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
            })
        }
    }
    
    // MARK: - Text Field Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            referralTextField.becomeFirstResponder()
        }
        else if textField == referralTextField && usernameTextField.validate() && passwordTextField.validate() {
            submit()
        }
        
        return false
    }
    
    
    
    @IBAction func textFieldEditingChanged() {
        submitButton.enabled = usernameTextField.validate() && passwordTextField.validate()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        if usernameTextField.isFirstResponder() && touch.view != usernameTextField {
            usernameTextField.resignFirstResponder()
        }
        else if passwordTextField.isFirstResponder() && touch.view != passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        else if referralTextField.isFirstResponder() && touch.view != referralTextField {
            referralTextField.resignFirstResponder()
        }
        
        super.touchesBegan(touches, withEvent: event)
    }

}
