//
//  AlertViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/9/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

let kAlertLabelStrokeColor = UIColor(red: 27/255, green: 20/255, blue: 100/255, alpha: 1)
let kAlertTitleColor =  UIColor(red: 213/255, green: 220/255, blue: 33/255, alpha: 1)


class AlertViewController: UIViewController {
    
    var alertButtons:[AlertButton]!
    var alertTitle: String!
    var alertMessage: String!
    
    var error: NSError!
    
    @IBOutlet weak var s_message: UILabel!
    @IBOutlet weak var s_title: UILabel!
    
    @IBOutlet weak var buttonView1: UIView!
    @IBOutlet weak var buttonView2: UIView!
  
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {

        print(self.alertMessage)
        configureAlert()
    }
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
    func addConstrains(aView: UIView, toView:UIView) {
        
        let topContraint = NSLayoutConstraint(item: aView, attribute: .Top, relatedBy: .Equal, toItem: toView, attribute: .Top, multiplier: 1, constant: 0)
        let leftContraint = NSLayoutConstraint(item: toView, attribute: .Trailing, relatedBy: .Equal, toItem: aView, attribute: .Trailing, multiplier: 1, constant: 0)
        let rightContraint = NSLayoutConstraint(item: toView, attribute: .Leading, relatedBy: .Equal, toItem: aView, attribute: .Leading, multiplier: 1, constant: 0)
        let downContraint = NSLayoutConstraint(item: toView, attribute: .Bottom, relatedBy: .Equal, toItem: aView, attribute: .Bottom, multiplier: 1, constant: 0)
        
        topContraint.active = true
        leftContraint.active = true
        rightContraint.active = true
        downContraint.active = true
        
    }
    
    func configureAlert(){
        
        // Generate by myself
        if error.code == -1 {
            // one button only
            if alertButtons.count == 1{
                
                s_message.attributedText = configureAlertMessage(alertMessage)
                s_title.attributedText = configureAlertTitle(alertTitle)
                
                buttonView1.addSubview(alertButtons[0])
                addConstrains(alertButtons[0], toView: buttonView1)

                buttonView2.removeFromSuperview()
                
            } else {
                s_message.attributedText = configureAlertMessage(alertMessage)
                s_title.attributedText = configureAlertTitle(alertTitle)
                
                buttonView1.addSubview(alertButtons[0])
                addConstrains(alertButtons[0], toView: buttonView1)

                buttonView2.addSubview(alertButtons[1])
                addConstrains(alertButtons[1], toView: buttonView2)
            }
        } else {
            
            
            
        }
        
        
    }
    
    
    func configureAlertTitle(str: String) -> NSAttributedString{
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : kAlertLabelStrokeColor,
            NSForegroundColorAttributeName : kAlertTitleColor,
            NSStrokeWidthAttributeName : -3.0
        ]
        return NSAttributedString(string:str, attributes: strokeTextAttributes)
        
    }
    
    func configureAlertMessage(str: String) -> NSAttributedString{
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : kAlertLabelStrokeColor,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : -3.0
        ]
        return NSAttributedString(string:str, attributes: strokeTextAttributes)
        
    }
    
    
    @IBAction func close() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}


// Custom Transitioning Delegate
extension AlertViewController: UIViewControllerTransitioningDelegate {
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
