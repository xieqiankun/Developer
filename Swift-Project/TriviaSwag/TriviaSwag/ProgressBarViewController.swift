//
//  ProgressBarViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/7/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

public extension UIImage {
    convenience init(color: UIColor, size: CGSize = CGSizeMake(1, 1)) {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(CGImage: image.CGImage!)
    }  
}

class ProgressBarViewController: UIViewController {

    var totalNum: Int?
    
    var totalScore = 40.0
    
    var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        initProcessBar()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initProcessBar() {
        
        let width = view.bounds.size.width
        let height = view.bounds.size.height
        print(height)
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        
        let image = UIImage(named: "ProgressCorrect")
        
        // Prepare mask image view
        let maskimage = UIImage(color: UIColor.whiteColor(), size: CGSizeMake(width, height/3))
        let maskImageView = UIImageView()
        maskImageView.image = maskimage
        maskImageView.frame = CGRectMake(0, height, width, 0)
        maskImageView.contentMode = UIViewContentMode.ScaleToFill
        // Set Mask image
        imageViewBackground.maskView = maskImageView
        
        imageViewBackground.image = image

        imageViewBackground.contentMode = UIViewContentMode.ScaleToFill
        view.backgroundColor = UIColor.clearColor()
        view.addSubview(imageViewBackground)
        view.sendSubviewToBack(imageViewBackground)
        
        self.imageView = imageViewBackground
        
    }
    
    // Update the scores
    func updateProgressBarScore(scores: [AnyObject]) {
        
        var temp = 0.0
        for num in scores {
            
                let asString = num
                let asDouble = Double(asString as! Double)
                temp += asDouble
        }
        let h = (self.totalScore - temp) / self.totalScore * Double(view.frame.size.height)
        let height = CGFloat(h)
        
        let newFrame = CGRectMake(0, height, view.bounds.width, height)
        
        UIView.animateWithDuration(0.25, delay: 0, options: [], animations: {
            self.imageView?.maskView?.frame = newFrame
            }, completion: nil)
    
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
