//
//  SettingDetailViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/20/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class SettingDetailViewController: UIViewController, SettingCellChangeDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = SettingSlaveTintColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }

    // MARK: - SettingCellChange Delegate
    
    func dismissCurrentViewController() {
        //navigationController?.popViewControllerAnimated(false)
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func showDetailSettingController(name: String) {

        let storyboard = UIStoryboard(name: "SettingTabs", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(name)
        vc.view.backgroundColor = SettingSlaveTintColor
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(vc, animated: false, completion: nil)
        }
        //performSegueWithIdentifier(name, sender: nil)
        
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
