//
//  UIView+shaking.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 6/10/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

extension UIView {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(self.center.x - 10, self.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(self.center.x + 10, self.center.y))
        self.layer.addAnimation(animation, forKey: "position")
    }
    
}