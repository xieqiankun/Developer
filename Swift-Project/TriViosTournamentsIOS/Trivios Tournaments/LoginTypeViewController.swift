//
//  LoginTypeViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/12/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class LoginTypeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func cancel() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "JustAttemptedLogin")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    let unlinkedErrorString = "This Facebook has not been linked to a triVios account. Please login/sign up for a triVios account and connect the account in the Settings page"
    @IBAction func loginWithFacebook() {
        if FBSDKAccessToken.currentAccessToken() != nil {
            //try loginfacebook route, if success, great! otherwise, signup
            requestFacebookUserInformation({
                error in
                if error != nil {
                    //Error getting facebook user information
                    dispatch_async(dispatch_get_main_queue(), {
                        let alert = UIAlertController(title: "There was a Problem", message: "There was an error! \(error?.description)", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                } else {
                    gStackLoginWithFacebook(FBSDKAccessToken.currentAccessToken().tokenString, facebookID: globalSavedFacebookUser["id"] as! String, completion: {
                        error in
                        if error != nil {
                            if error!.domain == self.unlinkedErrorString {
                                //We have FB permissions, but the user isn't in the database, so let's sign them up
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.performSegueWithIdentifier("FacebookLoginSegue", sender: nil) //This segue is poorly named; it actually goes to the sign up page
                                })
                            } else {
                                //There was a different error... likely the access token was not valid.
                                dispatch_async(dispatch_get_main_queue(), {
                                    let alert = UIAlertController(title: "There was a Problem", message: "There was an error! \(error!.domain)", preferredStyle: .Alert)
                                    let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                                    alert.addAction(okAction)
                                    self.presentViewController(alert, animated: true, completion: nil)
                                })
                            }
                        } else {
                            //Success! We have logged the returning user in through facebook
                            dispatch_async(dispatch_get_main_queue(), {
                                let alert = UIAlertController(title: "Log In Successful", message: "Welcome Back to Trivios Tournaments!", preferredStyle: .Alert)
                                let okAction = UIAlertAction(title: "Start Playing", style: .Cancel, handler: {
                                    completed in
                                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                                })
                                alert.addAction(okAction)
                                self.presentViewController(alert, animated: true, completion: nil)
                            })
                        }
                    })
                }
            })
        }
        else {
            //go out to facebook, then come back and do FacebookLoginSegue
            let loginManager = FBSDKLoginManager()
            loginManager.logInWithReadPermissions(["public_profile","email","user_friends"], handler: {
                result, error in
                if error != nil {
                    //There was a Facebook error
                    dispatch_async(dispatch_get_main_queue(), {
                        let alert = UIAlertController(title: "There was a Problem", message: "There was an error! \(error?.description)", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
                else if result.isCancelled == true {
                    //User cancelled the login
                    dispatch_async(dispatch_get_main_queue(), {
                        let alert = UIAlertController(title: "Cancelled Login", message: "You cancelled the login through Facebook.", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
                else {
                    //User has logged in via Facebook (should we check result.grantedPermissions? Are we asking for anything that can be denied? Should we check later?
                    requestFacebookUserInformation({
                        error2 in
                        if error2 != nil {
                            //There was an error getting user data from Facebook
                            dispatch_async(dispatch_get_main_queue(), {
                                let alert = UIAlertController(title: "There was a Problem", message: "There was an error! \(error2?.description)", preferredStyle: .Alert)
                                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                                alert.addAction(okAction)
                                self.presentViewController(alert, animated: true, completion: nil)
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.performSegueWithIdentifier("FacebookLoginSegue", sender: nil)
                            })
                        }
                    })
                }
            })
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "FacebookLoginSegue" {
            let destinationVC = segue.destinationViewController as! LoginUsernameViewController
            destinationVC.fbToken = FBSDKAccessToken.currentAccessToken().tokenString
            destinationVC.fbData = globalSavedFacebookUser
            destinationVC.emailAddress = globalSavedFacebookUser["email"] as! String
        }
    }
    

}
