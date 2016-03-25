//
//  LoginEmailViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/12/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class LoginEmailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailTextField: TextFieldValidator!
    @IBOutlet var enterPasswordLabel: UILabel!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var submitButton: UIBarButtonItem!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var emailVerificationLabel: UILabel!
    
    let REGEX_EMAIL = "[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Load Regexps
        emailTextField.addRegx(REGEX_EMAIL, withMsg: "Enter Valid Email Address")
        emailTextField.presentInView = view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "UsernameSegue" {
            let destinationVC = segue.destinationViewController as! LoginUsernameViewController
            destinationVC.emailAddress = emailTextField.text!
        }
    }

    let errorFindingEmailString = "Error Finding Email"
    func submitEmailAddress() {
        triviaVerifyEmail(emailTextField.text!, completion: {
            error in
            if error != nil {
                if error!.domain == self.errorFindingEmailString {
                    dispatch_async(dispatch_get_main_queue(), {
                        let alert = UIAlertController(title: "There was a Problem", message: "There was an error! \(error!.domain)", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.unhidePasswordEntry()
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("UsernameSegue", sender: nil)
                })
            }
        })
    }
    
    func login() {
        triviaUserLogin(emailTextField.text!, password: passwordTextField.text!, completion: {
            error in
            dispatch_async(dispatch_get_main_queue(), {
                if error != nil {
                    let alert = UIAlertController(title: "There was a Problem", message: "There was an error! \(error?.domain)", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Log In Successful", message: "Welcome Back to Trivios Tournaments!", preferredStyle: .Alert)
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
    
    @IBAction func submitButtonPressed() {
        if passwordTextField.hidden == true && emailTextField.validate() {
            submitEmailAddress()
        }
        else if passwordTextField.hidden == false {
            login()
        }
    }
    
    
    // MARK: - Text Field Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField && emailTextField.validate() {
            submitEmailAddress()
        }
        else if textField == passwordTextField {
            login()
        }
        
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            submitButton.enabled = emailTextField.validate()
        }
        else if textField == passwordTextField {
            submitButton.enabled = (passwordTextField.text!.characters.count > 0)
        }
        
        return true
    }
    
    
    func unhidePasswordEntry() {
        dispatch_async(dispatch_get_main_queue(), {
            self.passwordTextField.becomeFirstResponder()
            
            self.enterPasswordLabel.hidden = false
            self.passwordTextField.hidden = false
            self.forgotPasswordButton.hidden = false
            
            self.emailVerificationLabel.hidden = true
            
            self.emailTextField.userInteractionEnabled = false
            self.emailTextField.alpha = 0.5
        })
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        if emailTextField.isFirstResponder() && touch!.view != emailTextField {
            emailTextField.resignFirstResponder()
        }
        else if passwordTextField.isFirstResponder() && touch!.view != passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        
        super.touchesBegan(touches, withEvent: event)
    }
}
