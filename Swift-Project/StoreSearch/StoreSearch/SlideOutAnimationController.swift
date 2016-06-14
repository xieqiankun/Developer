//
//  SlideOutAnimationController.swift
//  StoreSearch
//
//  Created by 谢乾坤 on 4/27/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

import UIKit
class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if let fromView = transitionContext.viewForKey( UITransitionContextFromViewKey),
            let containerView = transitionContext.containerView() {
            let duration = transitionDuration(transitionContext)
            
            UIView.animateWithDuration(duration, animations: {
                fromView.center.y -= containerView.bounds.size.height
                fromView.transform = CGAffineTransformMakeScale(0.5, 0.5)
                }, completion: { finished in
                    transitionContext.completeTransition(finished)
            })
        }
    }
}