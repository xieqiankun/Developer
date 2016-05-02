//
//  ProfileViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/2/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label1: UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let strokeTextAttributes = [
            NSFontAttributeName: UIFont(name: "GROBOLD", size: label.font.pointSize)!,
            NSStrokeColorAttributeName : view.backgroundColor!,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : -3.0
            ]
        label.attributedText = NSAttributedString(string: "Sam Zoll", attributes: strokeTextAttributes)
        label.adjustsFontSizeToFitWidth = true
        label1.adjustsFontSizeToFitWidth = true
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

}
