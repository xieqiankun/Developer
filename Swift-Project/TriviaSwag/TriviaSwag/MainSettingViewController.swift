//
//  MainSettingViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/6/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit


let SettingMasterBackgroundColor = UIColor(red: 187/255, green: 197/255, blue: 11/255, alpha: 1)
let SettingMasterSelectedCellColor = UIColor(red: 221/255, green: 226/255, blue: 133/255, alpha: 1)

let SettingSlaveCellColor = UIColor(red: 187/255, green: 197/255, blue: 11/255, alpha: 1)
let SettingSlaveTintColor = UIColor(red: 213/255, green: 220/255, blue: 32/255, alpha: 1)
let SettingSlaveImageTintColor = UIColor(red: 27/255, green: 20/255, blue: 100/255, alpha: 1)

class MainSettingViewController: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        modalPresentationStyle = .Custom
        transitioningDelegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
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

// Custom Transitioning Delegate
extension MainSettingViewController: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController( presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        
        return DimmingPresentationController( presentedViewController: presented, presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController( presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return FadeInAnimationController()
    }
    
    func animationControllerForDismissedController( dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeOutAnimationController()
    }
    
}






