//
//  GameViewController+RippleAnimation.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/31/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

extension GameViewController {
    
    struct Option {
        var radius = CGFloat(30.0)
        var duration = 0.4
        var fillColor = UIColor.clearColor()
        var scale = CGFloat(3.0)
    }
    
    func rippleTouchAnimation(view: UIView, location: CGPoint, option: Option) {
        
        let newView = UIView()
        newView.frame = CGRectMake(location.x - 100, location.y - 100, 200.0, 200.0)
        newView.layer.cornerRadius = 100
        newView.backgroundColor = option.fillColor
        
        if view.subviews.count > 0 {
            view.insertSubview(newView, belowSubview: view.subviews[0])
        } else {
            view.addSubview(newView)
        }
        
        newView.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(option.duration, delay: 0, options: [], animations: {
            
            newView.transform = CGAffineTransformMakeScale(3, 3)
            
            }, completion: {
                (true) in
                newView.removeFromSuperview()
                dispatch_async(dispatch_get_main_queue(), { 
                    view.backgroundColor = option.fillColor
                })
        })
        
        
    }

    
    
    
    
    
    
    
    
    
}