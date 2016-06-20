//
//  BedNode.swift
//  CatNap
//
//  Created by 谢乾坤 on 6/17/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import SpriteKit

import SpriteKit
class BedNode: SKSpriteNode, CustomNodeEvents {
    
    func didMoveToScene() {
        print("bed added to scene")
        
        let bedBodySize = CGSize(width: 40.0, height: 30.0)
        physicsBody = SKPhysicsBody(rectangleOfSize: bedBodySize)
        physicsBody!.dynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.Bed
        physicsBody!.collisionBitMask = PhysicsCategory.None
    }
}