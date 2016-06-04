//
//  LoginViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/22/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    //Facebook Login
    var fbToken: String?
    var fbData: [NSObject: AnyObject]?
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]


    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func login() {
        
        triviaUserLogin(self.email.text!, password: self.password.text!) { (error) in
            
            
        }
        
    }
    
    
    @IBAction func loginWithFacebook(sender: UIButton) {
        
        loginToFacebook()
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
               triviaUserLoginWithFacebook(self.fbToken!, fbID: result.token.userID, completion: { (error) in
                    // update the ui
                
               })
            }
            
        }
    }
    
    
    //UITextFieldDelegate Functions for Text Fields
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
//        UIView.animateWithDuration(0.5, animations: {
//            
//            
//            UIView.beginAnimations(nil, context: nil)
//            UIView.setAnimationDuration(0.5)
//            UIView.setAnimationDelay(0)
//            UIView.setAnimationCurve(.EaseOut)
//            
//            self.view.bounds.origin.y = 80
//            
//            UIView.commitAnimations()
//        })
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
