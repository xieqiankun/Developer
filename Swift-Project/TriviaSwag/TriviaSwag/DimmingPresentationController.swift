//
//  DimmingPresentationController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/27/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit
class DimmingPresentationController: UIPresentationController {
    
    lazy var dimmingView = GradientView(frame: CGRect.zero)
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        containerView!.insertSubview(dimmingView, atIndex: 0)
        dimmingView.alpha = 0
        
        if let transitionCoordinator = presentedViewController.transitionCoordinator() { transitionCoordinator.animateAlongsideTransition({ _ in
            self.dimmingView.alpha = 1
            }, completion: nil)
        }
    }
    
    override func shouldRemovePresentersView() -> Bool {
        return false
    }
    
    override func dismissalTransitionWillBegin() {
        if let transitionCoordinator =  presentedViewController.transitionCoordinator() { transitionCoordinator.animateAlongsideTransition({ _ in
            self.dimmingView.alpha = 0
            }, completion: nil)
        }
    }
}
