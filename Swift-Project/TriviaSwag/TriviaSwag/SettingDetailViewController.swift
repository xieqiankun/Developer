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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - SettingCellChange Delegate
    
    func dismissCurrentViewController() {
        navigationController?.popViewControllerAnimated(false)
    }
    
    func showDetailSettingController(name: String) {
        performSegueWithIdentifier(name, sender: nil)
        
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
