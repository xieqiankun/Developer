//
//  FadeInAnimationController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/28/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

import UIKit
class FadeInAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let toView = transitionContext.viewForKey( UITransitionContextToViewKey),
            let containerView = transitionContext.containerView() {
            
            toView.frame = transitionContext.finalFrameForViewController(toViewController)
            
            containerView.addSubview(toView)
            toView.alpha = 0.2
            
            UIView.animateKeyframesWithDuration( transitionDuration(transitionContext), delay: 0,
                                                 options: .CalculationModeCubic, animations:
                {
                    containerView.addSubview(toView)
                    
                    toView.alpha = 1
//                    UIView.addKeyframeWithRelativeStartTime( 0.0, relativeDuration: 0.334, animations: {
//                        toView.transform = CGAffineTransformMakeScale(1.2, 1.2) })
                }, completion: {
                    finished in transitionContext.completeTransition(finished)
            })
        }
    }
}