//
//  GameViewController.swift
//  tvOSTouchTest
//
//  Created by 谢乾坤 on 6/16/16.
//  Copyright (c) 2016 QiankunXie. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    let gameScene = GameScene(size:CGSize(width: 2048, height: 1536))
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        gameScene.scaleMode = .AspectFill
        skView.presentScene(gameScene)
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event:
        UIPressesEvent?) {
        gameScene.pressesBegan(presses, withEvent: event)
    }
    override func pressesEnded(presses: Set<UIPress>, withEvent event:
        UIPressesEvent?) {
        gameScene.pressesEnded(presses, withEvent: event)
    }
    
}