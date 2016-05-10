//
//  AlertViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/9/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    var alertButtons:[AlertButton]!
    var alertTitle: String!
    var alertMessage: String!
    
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

    }
    override func viewWillAppear(animated: Bool) {
        
        s_message.text = alertMessage

        buttonView1.addSubview(alertButtons[0])
        
        addConstrains(alertButtons[0], toView: buttonView1)
        //buttonView1.setNeedsLayout()
        

        buttonView2.addSubview(alertButtons[1])
        addConstrains(alertButtons[1], toView: buttonView2)
 
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
        
        // aView.superview!.addConstraints([topContraint,leftContraint,rightContraint,downContraint])
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
