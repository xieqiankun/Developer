//
//  TournamentDetailImageViewController.swift
//  TriviaSwag
//
//  Created by Jared Eisenberg on 6/8/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class TournamentDetailImageViewController: UIViewController {
    
    
    @IBOutlet weak var enlargedImage: UIImageView!
    
    var pendingImg: UIImage?
    
    override func viewDidLoad() {
        if let img = pendingImg{
            enlargedImage.image = img
            enlargedImage.layer.cornerRadius = 10
            enlargedImage.layer.borderWidth = 5
            enlargedImage.layer.borderColor = UIColor(red: 46.0/255, green: 49.0/255, blue: 141.0/255, alpha: 1).CGColor
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        modalPresentationStyle = .Custom
        transitioningDelegate = self
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        
        let touchLocation = touch?.locationInView(self.view)
        
        if (!enlargedImage.pointInside(touchLocation!, withEvent: nil)){
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}


extension TournamentDetailImageViewController: UIViewControllerTransitioningDelegate {
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