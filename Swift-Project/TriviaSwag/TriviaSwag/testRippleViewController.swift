//
//  testRippleViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/24/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

class testRippleViewController: UIViewController {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var imageview1: UIImageView!
    @IBOutlet weak var imageview2: UIImageView!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        imageview1.image = UIImage.animatedImageNamed("shooterMcGavin_", duration: 1.5)
        let gif = UIImage.gifWithName("shooterMcGavin")
        imageview2.image = gif
        
    }
    
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
        
        view.addSubview(newView)
        
        newView.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(0.5, delay: 0, options: [], animations: {
            
            newView.transform = CGAffineTransformMakeScale(1.5, 1.5)
            
            }, completion: {
                (true) in
                newView.removeFromSuperview()
                view.backgroundColor = option.fillColor
        })
        
        
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        for touch: AnyObject in touches {
            let t: UITouch = touch as! UITouch
            let location = t.locationInView(self.view)
            
            
            if view.hitTest(location, withEvent: nil) == view1{
                print("hit here")
//                var option = Ripple().option()
//                //configure
//                option.borderWidth = CGFloat(5.0)
//                option.radius = CGFloat(30.0)
//                option.duration = CFTimeInterval(4)
//                option.borderColor = UIColor.redColor()
//                option.fillColor = UIColor.redColor()
//                option.scale = CGFloat(3.0)
//                
//                print(view1.frame)
//                print(t.locationInView(view1))
//                print(t.locationInView(view))
//                let point = t.locationInView(view1)
//                print(CGPointMake(point.x + view1.frame.origin.x, point.y + view1.frame.origin.y))
//                
//                Ripple().run(self.view1, locationInView: t.locationInView(view1), option: option){
//                }
                let l = t.locationInView(view1)
                var option = Option()
                option.fillColor = UIColor.redColor()
                rippleTouchAnimation(view1, location:l, option: option)
                
            }
//            if view.hitTest(location, withEvent: nil) == view2{
//                
//                var option = Ripple().option()
//                //configure
//                option.borderWidth = CGFloat(5.0)
//                option.radius = CGFloat(30.0)
//                option.duration = CFTimeInterval(4)
//                option.borderColor = UIColor.redColor()
//                option.fillColor = UIColor.redColor()
//                option.scale = CGFloat(3.0)
//                
//                Ripple().run(self.view2, locationInView: t.locationInView(view2), option: option){
//                }
//            } else {
//                
//                var option = Ripple().option()
//                //configure
//                option.borderWidth = CGFloat(5.0)
//                option.radius = CGFloat(30.0)
//                option.duration = CFTimeInterval(4)
//                option.borderColor = UIColor.redColor()
//                option.fillColor = UIColor.redColor()
//                option.scale = CGFloat(3.0)
//                
//                Ripple().run(self.view, locationInView: t.locationInView(view), option: option){
//                }
//
//            }
            
            

        }
    }
    
    
    
    
    
    
    
    
    
    
    
}