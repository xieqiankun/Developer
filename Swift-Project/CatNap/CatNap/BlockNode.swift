//
//  BlockNode.swift
//  CatNap
//
//  Created by 谢乾坤 on 6/17/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation
import SpriteKit
class BlockNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
    func didMoveToScene() {
        userInteractionEnabled = true
    }
    func interact() {
        userInteractionEnabled = false
        runAction(SKAction.sequence([
            SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false),
            SKAction.scaleTo(0.8, duration: 0.1),
            SKAction.removeFromParent()
        ]))
        
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event:
        UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        print("destroy block")
        interact()
    }
}