//
//  testqstackcontroller.swift
//  Trivios Tournaments
//
//  Created by 谢乾坤 on 3/23/16.
//  Copyright © 2016 Purple Gator. All rights reserved.
//

import UIKit

class testqstackcontroller: UIViewController {

    override func viewDidLoad() {
        
        gStackLoginWithAppID("308189542", appKey: "/o3I3goKCQ==") { (error) -> Void in
            
            
        }

    }
    @IBAction func assssss(sender: AnyObject) {
        
        gStackFetchTournaments({ (error, tournaments) -> Void in
        })
    }
    
}
