//
//  StatusUpdateViewController.swift
//  TriviaSwag
//
//  Created by Jared Eisenberg on 6/4/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class StatusUpdateViewController: UIViewController, UITextViewDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        modalPresentationStyle = .Custom
        transitioningDelegate = self
        
    }
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var status: UITextView!
    @IBOutlet weak var statusLength: UILabel!
    
    override func viewDidLoad() {
        if let cancelImage = UIImage(named: "CancelButton-Untouched"){
             cancelButton.setImage(cancelImage, forState: .Normal)
        }
        if let cancelPushed = UIImage(named: "CancelButton-Touched"){
             cancelButton.setImage(cancelPushed, forState: .Highlighted)
        }
        if let updateImage = UIImage(named: "SubmitButton-Untouched"){
            updateButton.setImage(updateImage, forState: .Normal)
        }
        if let updatePushed = UIImage(named: "SubmitButton-Touched"){
            updateButton.setImage(updatePushed, forState: .Highlighted)
        }
        status.text = triviaCurrentUser!.status
        statusLength.text = String(status.text.characters.count) + "/60"
        status.delegate = self
    }
    
    

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //close keyboard if active
    }
    
    
    @IBAction func update(sender: UIButton) {
        triviaSetCurrentUserStatus(status.text, completion: { (error: NSError?) in
            if (error == nil){
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
   
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        else if (status.text.characters.count >= 60){
            if (text == ""){
                statusLength.text = String(status.text.characters.count - 1) + "/60"
                return true
            }
            return false
        }
        else if (status.text.characters.count + text.characters.count > 60){
            return false
        }
        if (text == ""){
            statusLength.text = String(status.text.characters.count - 1) + "/60"
            if (status.text.characters.count == 0){
                statusLength.text = "0/60"
            }
        }
        else {
            statusLength.text = String(status.text.characters.count + 1) + "/60"
        }
        
        return true
    }
    
    
}

extension StatusUpdateViewController: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController( presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        
        return DimmingPresentationController( presentedViewController: presented, presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController( presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return FadeInAnimationController()
    }
    
    func animationControllerForDismissedController( dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeOutAnimationController()
    }
    
}
