//
//  ComposeMessageViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/14/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class ComposeMessageViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var recipientTextField: UITextField!
    @IBOutlet var messageTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
    @IBAction func sendNewMessage() {
        if recipientTextField.text!.characters.count == 0 {
            let alert = UIAlertController(title: "Recipient Field Empty", message: "Recipient Field Cannot Be Empty", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
        }
        else if messageTextView.text.characters.count == 0 {
            let alert = UIAlertController(title: "Message Body Empty", message: "Message Body Cannot Be Empty", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
        }
        else if messageTextView.text.characters.count > 1000 {
            let alert = UIAlertController(title: "Message Too Long", message: "Message Body Cannot Exceed 1000 Characters", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
        }
        else if recipientTextField.text == triviaCurrentUser?.displayName {
            let alert = UIAlertController(title: "Don't Be Silly!", message: "You can't send a message to yourself, silly!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
        }
        else {
            if messageTextView.isFirstResponder() {
                messageTextView.resignFirstResponder()
            }
            else if recipientTextField.isFirstResponder() {
                recipientTextField.resignFirstResponder()
            }
            let message = gStackMessage(recipientName: recipientTextField.text!, message: messageTextView.text)
            gStackSendMessage(message, completion: {
                error, updatedInbox in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: "There was an error when we tried to send the message (check the logs)", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    if self.view.window != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        })
                    }
                }
            })
        }
    }
    
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    //MARK: - Text Field Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        messageTextView.becomeFirstResponder()
        
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        if recipientTextField.isFirstResponder() && touch!.view != recipientTextField {
            recipientTextField.resignFirstResponder()
        }
        else if messageTextView.isFirstResponder() && touch!.view != messageTextView {
            messageTextView.resignFirstResponder()
        }
        
        super.touchesBegan(touches, withEvent: event)
    }
}
