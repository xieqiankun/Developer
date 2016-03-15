//
//  ViewController.swift
//  GStack-Swift-SDK
//
//  Created by 谢乾坤 on 3/4/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let g = GStack.sharedInstance
        
        g.gStackLoginWithAppID("308189542", appKey: "/o3I3goKCQ==") { (error) -> Void in
            print("I am here")

        }
        
        
        
    }
    @IBAction func sssss(sender: AnyObject) {
        GStack.sharedInstance.gStackFetchTournaments { (error, tournaments) -> Void in
            print("I am here to get the tournamnets")
            
        }
    }

    @IBAction func seedata(sender: AnyObject) {
        
        let t = GStack.sharedInstance.GStackBracketTournaments[0]
        
        GStack.sharedInstance.GStackStartGameForTournament(t) { (error, game) -> Void in
            print("I am nearly start the game")

            //need to set the delegate
            
            game?.startGame()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

