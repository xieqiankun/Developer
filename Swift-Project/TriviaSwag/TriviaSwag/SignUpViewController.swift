//
//  SignUpViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/21/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var referralTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var emailVerifyButton: UIButton!
    
    //Facebook part
    @IBOutlet var btnFacebook: UIButton!
    @IBOutlet var lblName: UILabel!
    var fbToken: String?
    var fbData: [NSObject: AnyObject]?
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]


    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideFields()
        // Do any additional setup after loading the view.
    }
    
    func hideFields() {
        
        self.usernameTextField.hidden = true
        self.passwordTextField.hidden = true
        self.referralTextField.hidden = true
        self.submitButton.hidden = true
    }
    
    func displayFields() {
        
        self.usernameTextField.hidden = false
        self.passwordTextField.hidden = false
        self.referralTextField.hidden = false
        self.submitButton.hidden = false
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }
    
    func isValidUsername(testStr: String) -> Bool {
        let regex = "^.{4,11}$"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluateWithObject(testStr)
    }
    
    func isValidPassword(testStr: String) -> Bool {
        let regex = "([-@./#&+\\w]){6,24}"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluateWithObject(testStr)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpWithFacebook() {
        loginToFacebook()
    }
    

    @IBAction func verifyEmailAddress(sender: AnyObject) {
        
        triviaVerifyEmail(emailTextField.text!) { (error) in
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.displayFields()
                    self.emailTextField.enabled = false
                    self.emailVerifyButton.enabled = false
                })

            } else {
                dispatch_async(dispatch_get_main_queue(), { 
                    let alert = UIAlertController(title: "There is a problem", message: error?.domain, preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: {self.emailTextField.text = ""})
                })

            }
        }
        
    }
    
    @IBAction func signup() {
        
        if isValidPassword(passwordTextField.text!) && isValidUsername(usernameTextField.text!) {
            
            if self.fbToken == nil && self.fbData == nil {
            
                // TODO: Change the avatar latter
                triviaSignUp(usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, avatar:"" , deviceId: UIDevice.currentDevice().identifierForVendor?.UUIDString, referralCode: referralTextField.text!, completion: { (error) in
                    if error != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            let alert = UIAlertController(title: "There is a problem", message: error?.domain, preferredStyle: .Alert)
                            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                            alert.addAction(okAction)
                            self.presentViewController(alert, animated: true, completion: {self.emailTextField.text = ""})
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            let alert = UIAlertController(title: "Sign up successfully", message: "Hello I am Qiankun", preferredStyle: .Alert)
                            // TODO: Change completion handler later
                            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                            alert.addAction(okAction)
                            self.presentViewController(alert, animated: true, completion: {self.emailTextField.text = ""})
                            print("save token \(retrieveLogInToken())")
                        })

                        // Send notice for user logged in
                        NSNotificationCenter.defaultCenter().postNotificationName(triviaUserSuccessfullyLoggedIn, object: nil)
                        
                    }
                })
            } else if let fbtoken = self.fbToken, fbdata = self.fbData {
                
                // need to verify if user gives the permission of email
                triviaFacebookSignUp(usernameTextField.text!, email: fbdata["email"] as! String, password: passwordTextField.text!, avatar: "", deviceId: UIDevice.currentDevice().identifierForVendor?.UUIDString, referralCode: referralTextField.text!, fbToken: fbtoken, fbData: fbdata, completion: { (error) in
                    
                    if error != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            let alert = UIAlertController(title: "There is a problem", message: error?.domain, preferredStyle: .Alert)
                            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                            alert.addAction(okAction)
                            self.presentViewController(alert, animated: true, completion: {self.emailTextField.text = ""})
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            let alert = UIAlertController(title: "Sign up successfully", message: "Hello I am Qiankun", preferredStyle: .Alert)
                            // TODO: Change completion handler later
                            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                            alert.addAction(okAction)
                            self.presentViewController(alert, animated: true, completion: {self.emailTextField.text = ""})
                            print("save token \(retrieveLogInToken())")
                        })
                        
                        // Send notice for user logged in
                        NSNotificationCenter.defaultCenter().postNotificationName(triviaUserSuccessfullyLoggedIn, object: nil)
                        
                    }

                })
            }
        }
    }
    
    
    // MARK: - login with facebook
    func loginToFacebook() {
        
        // This situation should happen
        if FBSDKAccessToken.currentAccessToken() != nil {
            //For debugging, when we want to ensure that facebook login always happens
            FBSDKLoginManager().logOut()
            //Otherwise do:
            return
        }
        
        FBSDKLoginManager().logInWithReadPermissions(self.facebookReadPermissions, fromViewController: self) { (result, error) in
            if error != nil {
                
                FBSDKLoginManager().logOut()
                
            } else if result.isCancelled {
                
                FBSDKLoginManager().logOut()
                
            } else {
                
                self.fbToken = result.token.tokenString
                
                // After getting permission, fetch the data from Facebook
                requestFacebookUserInformation({ (result, error) in
                    if error == nil {
                        self.fbData = result
                        dispatch_async(dispatch_get_main_queue(), {
                            //update the ui for sign up
                            self.displayFields()
                            self.emailTextField.enabled = false
                            self.emailVerifyButton.enabled = false
                        })
                        
                    } else {
                        print("error in fetch fb date \(error?.domain)")
                    }
                    
                })
                
            }

        }
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
        let touch = touches.first
        if emailTextField.isFirstResponder() && touch!.view != emailTextField {
            emailTextField.resignFirstResponder()
        }
        else if passwordTextField.isFirstResponder() && touch!.view != passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        else if usernameTextField.isFirstResponder() && touch?.view != usernameTextField {
            usernameTextField.resignFirstResponder()
        }
        else if referralTextField.isFirstResponder() && touch?.view != referralTextField {
            referralTextField.resignFirstResponder()
        }
        
        super.touchesBegan(touches, withEvent: event)
    }
    
    //MARK: - Text Delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        emailVerifyButton.enabled = isValidEmail(newText as String)
        return true
    }
    
}
