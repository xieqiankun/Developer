//
//  FadeOutAnimationController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/28/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//


import UIKit
class FadeOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if let fromView = transitionContext.viewForKey( UITransitionContextFromViewKey),
            let containerView = transitionContext.containerView() {
            let duration = transitionDuration(transitionContext)
            
            UIView.animateWithDuration(duration, animations: {
                
                fromView.alpha = 0
                }, completion: { finished in
                    transitionContext.completeTransition(finished)
            })
        }
    }
}