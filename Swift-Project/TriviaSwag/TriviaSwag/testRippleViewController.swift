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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        for touch: AnyObject in touches {
            var t: UITouch = touch as! UITouch
            let location = t.locationInView(self.view)
            
            
            if view.hitTest(location, withEvent: nil) == view1{
                print("hit here")
                var option = Ripple.option()
                //configure
                option.borderWidth = CGFloat(5.0)
                option.radius = CGFloat(30.0)
                option.duration = CFTimeInterval(4)
                option.borderColor = UIColor.redColor()
                option.fillColor = UIColor.redColor()
                option.scale = CGFloat(3.0)
                
                print(view1.frame)
                print(t.locationInView(view1))
                print(t.locationInView(view))
                let point = t.locationInView(view1)
                print(CGPointMake(point.x + view1.frame.origin.x, point.y + view1.frame.origin.y))
                
                Ripple.run(self.view1, locationInView: t.locationInView(view1), option: option){
                }
            }
            if view.hitTest(location, withEvent: nil) == view2{
                
                var option = Ripple.option()
                //configure
                option.borderWidth = CGFloat(5.0)
                option.radius = CGFloat(30.0)
                option.duration = CFTimeInterval(4)
                option.borderColor = UIColor.redColor()
                option.fillColor = UIColor.redColor()
                option.scale = CGFloat(3.0)
                
                Ripple.run(self.view2, locationInView: t.locationInView(view2), option: option){
                }
            } else {
                
                var option = Ripple.option()
                //configure
                option.borderWidth = CGFloat(5.0)
                option.radius = CGFloat(30.0)
                option.duration = CFTimeInterval(4)
                option.borderColor = UIColor.redColor()
                option.fillColor = UIColor.redColor()
                option.scale = CGFloat(3.0)
                
                Ripple.run(self.view, locationInView: t.locationInView(view), option: option){
                }

            }
            
            

        }
    }
    
    
    
    
    
    
    
    
    
    
    
}