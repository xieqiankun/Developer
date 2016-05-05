//
//  NavBarViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/5/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class NavBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let des = segue.destinationViewController as? ProfileViewController where segue.identifier == "MyProfile" {
            
            if let user = triviaCurrentUser {
                des.currentUser = user
            } else {
                des.currentUser = triviaUser()
            }
            
        }
        
    }
 

}
