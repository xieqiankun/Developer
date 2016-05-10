//
//  ClockViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/11/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit
import AVFoundation

class ClockViewController: UIViewController {

    var time = 0
    
    var timer: NSTimer?
    
    // sound for timing
    var soundCountdown: AVAudioPlayer?

    
    @IBOutlet weak var timeLabel: UILabel!
    
    deinit{
        
        print("deinit the clock view controller")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let soundcount = self.setupAudioPlayerWithFile("Countdown_Clock", type: "wav"){
            self.soundCountdown = soundcount
            self.soundCountdown?.prepareToPlay()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        //1
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        //2
        var audioPlayer:AVAudioPlayer?
        
        // 3
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimerForClock(num: Int) {
        self.time = num/1000
        
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
            
            self.timeLabel.alpha = 1
            self.timeLabel.text = String(self.time)
            
            }, completion: nil)
        
        if self.timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ClockViewController.timerFireMethod), userInfo: nil, repeats: true)
        
    }
    
    func timerFireMethod() {
        
        // protect the timer
        if self.time == 0 {
            if let t = self.timer {
                t.invalidate()
                self.timer = nil
            }
        }
        self.time -= 1
        
        UIView.transitionWithView(self.timeLabel, duration: 0.2, options: .TransitionCrossDissolve, animations: {
            self.timeLabel.text = String(self.time)
            }, completion: nil)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.soundCountdown?.play()
        }
        
    }
    
    // Stop the timer
    func invalidateClockTimer() {
        
        if self.timer != nil {
            print("invaildate")
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    // Clear clock
    func clearClock() {
        
        UIView.animateWithDuration(0.5) {
            self.timeLabel.text = ""
            self.timeLabel.alpha = 0
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
