//
//  CatNode.swift
//  CatNap
//
//  Created by 谢乾坤 on 6/17/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation
import SpriteKit

let kCatTappedNotification = "kCatTappedNotification"


class CatNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
    
    private var isDoingTheDance = false
    
    func didMoveToScene() {
        print("cat added to scene")
        userInteractionEnabled = true
        
        let catBodyTexture = SKTexture(imageNamed: "cat_body_outline")
        parent!.physicsBody = SKPhysicsBody(texture: catBodyTexture, size: catBodyTexture.size())
        parent!.physicsBody!.categoryBitMask = PhysicsCategory.Cat
        parent!.physicsBody!.collisionBitMask = PhysicsCategory.Block | PhysicsCategory.Edge |  PhysicsCategory.Spring
        parent!.physicsBody!.contactTestBitMask = PhysicsCategory.Bed | PhysicsCategory.Edge
    }
    
    func interact() {
         NSNotificationCenter.defaultCenter().postNotificationName(kCatTappedNotification, object: nil)
        if DiscoBallNode.isDiscoTime && !isDoingTheDance {
            isDoingTheDance = true
            //add dance action
            let move = SKAction.sequence([
                SKAction.moveByX(80, y: 0, duration: 0.5),
                SKAction.waitForDuration(0.5),
                SKAction.moveByX(-30, y: 0, duration: 0.5)
                ])
            let dance = SKAction.repeatAction(move, count: 3)
            parent!.runAction(dance, completion: {
                self.isDoingTheDance = false
            })
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event:
        UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        interact()
    }
    
    func wakeUp() {
        // 1
        for child in children {
            child.removeFromParent()
        }
        texture = nil
        color = SKColor.clearColor()
        // 2 
        //TODO:- Don't know why
        let catAwake = SKNode(fileNamed:
            "CatWakeUp")!.childNodeWithName("cat_awake")!
        // 3
        catAwake.moveToParent(self)
       // addChild(catAwake)
        catAwake.position = CGPoint(x: -30, y: 100)
    }
    
    func curlAt(scenePoint: CGPoint) {
        parent!.physicsBody = nil
        for child in children {
            child.removeFromParent()
        }
        texture = nil
        color = SKColor.clearColor()
        let catCurl = SKNode(fileNamed:
            "CatCurl")!.childNodeWithName("cat_curl")!
        catCurl.moveToParent(self)
        catCurl.position = CGPoint(x: -30, y: 100)
        var localPoint = parent!.convertPoint(scenePoint, fromNode: scene!)
        localPoint.y += frame.size.height/3
        
        runAction(SKAction.group([
            SKAction.moveTo(localPoint, duration: 0.66),
            SKAction.rotateToAngle(0, duration: 0.5)
        ]))
    }
}






