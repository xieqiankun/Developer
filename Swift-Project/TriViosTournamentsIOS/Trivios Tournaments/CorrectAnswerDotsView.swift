//
//  CorrectAnswerDotsView.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 8/13/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class CorrectAnswerDotsView: UIView {
    
    var numberOfDots = 0
    var correctIndexes = Array<Int>()
    var incorrectIndexes = Array<Int>()
    
    var dots = Array<SingleDot>()
    
    init(frame: CGRect, howManyDots: Int) {
        super.init(frame: frame)
        
        numberOfDots = howManyDots
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var firstLayout = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if firstLayout == true {
            firstLayout = false
            for idx in 1...numberOfDots {
                let verticalPadding = CGFloat(10.0)
                let circleHeight = frame.height - 2*verticalPadding - 6 //-6 for expansion
                let horizontalPadding = (frame.size.width - CGFloat(CGFloat(numberOfDots) * circleHeight)) / CGFloat(numberOfDots + 1)
                let borderRect = CGRectMake(CGFloat(idx)*horizontalPadding+CGFloat(idx-1)*circleHeight, verticalPadding, circleHeight, circleHeight)
                
                let dot = SingleDot(frame: borderRect)
                dot.tag = idx
                dot.alpha = 0
                addSubview(dot)
                
                dots.append(dot)
            }
            animateInDots()
        }
        else {
            let expandWidthConstant = CGFloat(10)
            for dot in dots {
                if dot.correct == nil {
                    if correctIndexes.contains(dot.tag) {
                        dot.color = kCorrectBackgroundColor
                        dot.correct = true
                        dot.frame = CGRectMake(dot.frame.origin.x, dot.frame.origin.y, dot.frame.width+expandWidthConstant, dot.frame.height)
                        dot.setNeedsLayout()
                    }
                    else if incorrectIndexes.contains(dot.tag) {
                        dot.color = kWrongBackgroundColor
                        dot.correct = false
                        dot.frame = CGRectMake(dot.frame.origin.x, dot.frame.origin.y, dot.frame.width+expandWidthConstant, dot.frame.height)
                        dot.setNeedsLayout()
                    }
                }
            }
        }
    }
    
    func animateInDots() {
        let sortedDots = dots.sort({
            (dot1: SingleDot, dot2: SingleDot) -> Bool in
            return dot1.tag < dot2.tag
        })
        
        for idx in 0...sortedDots.count-1 {
            let dot = sortedDots[idx]
            UIView.animateWithDuration(0.5, delay: Double(idx)*0.3, options: [], animations: {
                dot.alpha = 1
                },
                completion: nil)
        }
    }
}

//With help from: http://stackoverflow.com/questions/10809280/drawrect-circle-and-animate-size-color
class SingleDot: UIView {
    var color = kUnansweredBackgroundColor
    var correct: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Tappable
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "dotTapped")
        addGestureRecognizer(gestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setLayerProperties()
        attachAnimations()
    }
    
    func setLayerProperties() {
        let theLayer = layer as! CAShapeLayer
        theLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height/2).CGPath
        theLayer.fillColor = color.CGColor
        theLayer.strokeColor = UIColor.whiteColor().CGColor
    }
    
    var transformed = false
    func attachAnimations() {
        if correct != nil && transformed == false {
            transformed = true
            attachColorAnimation()
            attachPathAnimation()
            animateInCheckmark()
        }
    }
    
    func attachPathAnimation() {
        let animation = animationWithKeyPath("path")
        animation.toValue = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height/2)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        layer.addAnimation(animation, forKey: animation.keyPath)
    }
    
    func attachColorAnimation() {
        let animation = animationWithKeyPath("fillColor")
        animation.fromValue = UIColor.whiteColor()
        layer.addAnimation(animation, forKey: animation.keyPath)
    }
    
    func animationWithKeyPath(keyPath: String) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.repeatCount = 1
        animation.duration = 1
        return animation
    }
    
    func animateInCheckmark() {
        var image = UIImage(named: "Checkmark")
        if correct == false {
            image = UIImage(named: "Xcheck")
        }
        let padding = CGFloat(3)
        let imageView = UIImageView(frame: CGRectMake(bounds.origin.x+padding, bounds.origin.y+padding, bounds.size.width-padding*2, bounds.size.height-padding*2))
        imageView.image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        imageView.transform = CGAffineTransformMakeScale(0.01, 0.01)
        imageView.tintColor = UIColor.whiteColor()
        addSubview(imageView)
        UIView.animateWithDuration(0.5, delay: 1.0, options: [], animations: {
            imageView.transform = CGAffineTransformMakeScale(1.3, 1.3)
            }, completion: {
                completed in
                UIView.animateWithDuration(0.3, animations: {
                    imageView.transform = CGAffineTransformIdentity
                }, completion: nil)
        })
    }
    
    
    //Tappable
    func dotTapped() {
        NSNotificationCenter.defaultCenter().postNotificationName("AnswerDotTapped", object: nil, userInfo: ["Index":tag])
    }
}
