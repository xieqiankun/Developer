//
//  TestViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/9/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func test() {
        
        let button1 = AlertButton(title: "aaaa", imageNames: [], style: .Normal)
        let button2 = AlertButton(title: "aaa", imageNames: [], style: .Normal)
        
        let vc = StoryboardAlertViewControllerFactory().createAlertViewController([button1,button2], title: "aaa", message: "aaaa")
        presentViewController(vc, animated: true, completion: nil)
        
    }

}
