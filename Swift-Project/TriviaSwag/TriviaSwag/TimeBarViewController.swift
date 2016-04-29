//
//  TimeBarViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/8/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class TimeBarViewController: UIViewController {

    // cause there may have two players
    var playerNum: String?
    
    var timeBar: UIImageView?
    
    var timer: NSTimer?
    
    deinit{
        
        print("deinit the time bar view controller")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // use when start to display answers
    func initTimeBar() {
        
        if timeBar != nil {
            timeBar?.removeFromSuperview()
        }

        
        self.timeBar = self.addTimeBarBackground(self.playerNum!)
        
        setupAnimation(timeBar!)
    }
    
    func addTimeBarBackground(figureName: String) -> UIImageView{
        
        let width = view.bounds.size.width
        let height = view.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: figureName)
        
        imageViewBackground.contentMode = UIViewContentMode.ScaleToFill
        view.backgroundColor = UIColor.clearColor()
        view.addSubview(imageViewBackground)
        view.sendSubviewToBack(imageViewBackground)
        
        return imageViewBackground
    }

    
    func setupAnimation(backgroundView: UIImageView){
        
        let tempBounds = backgroundView.bounds
        backgroundView.bounds = CGRectMake(0, 0, 0, tempBounds.height)
        backgroundView.alpha = 0;
        
        UIView.animateWithDuration(0.5, delay: 0, options: [], animations: {
            
            backgroundView.bounds = tempBounds
            backgroundView.alpha = 1
            
            }, completion: nil)
    }
    
    // clear the time bar
    
    func clearTimebar() {
        
        if self.timeBar != nil {
            
            self.clearAnimation(self.timeBar!)
            
        } else {
            print("Should add timebar background first")
        }

        
    }
    
    func clearAnimation(backgroundView: UIImageView){
        let tempBounds = backgroundView.bounds
        
        UIView.animateWithDuration(0.5, delay: 0, options: [], animations: {
            
            backgroundView.bounds = CGRectMake(0, 0, 0, tempBounds.height)
            backgroundView.alpha = 0
            
            }, completion: nil)

    }
    
    var step: Double?
    
    // start timing
    func startTiming(time: Int) {
        
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        
        self.step = Double(view.bounds.width) / Double(time / 1000) * 0.05
        
        // May remove this dispatch function further
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC)/2))

        dispatch_after(delayTime, dispatch_get_main_queue(), { () -> Void in
            
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(TimeBarViewController.startTimer), userInfo: nil, repeats: true)
        })
        

        
    }
    
    func startTimer(){
        
        let temp = self.timeBar?.bounds
        
        let newRect = CGRectMake(0, 0, CGFloat(Double((temp?.width)!) - step!), (temp?.height)!)
        
        UIView.animateWithDuration(0.05, delay:0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.timeBar?.bounds = newRect
            }, completion: nil)
        
    }

    // end timing for one player
    func invalidateTimer(){
        
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
