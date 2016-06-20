//
//  HintNode.swift
//  CatNap
//
//  Created by 谢乾坤 on 6/18/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import SpriteKit
class HintNode: SKSpriteNode, CustomNodeEvents {
    
    var arrowPath: CGPath {
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 0.5, y: 65.69))
        bezierPath.addLineToPoint(CGPoint(x: 74.99, y: 1.5))
        bezierPath.addLineToPoint(CGPoint(x: 74.99, y: 38.66))
        bezierPath.addLineToPoint(CGPoint(x: 257.5, y: 38.66))
        bezierPath.addLineToPoint(CGPoint(x: 257.5, y: 92.72))
        bezierPath.addLineToPoint(CGPoint(x: 74.99, y: 92.72))
        bezierPath.addLineToPoint(CGPoint(x: 74.99, y: 126.5))
        bezierPath.addLineToPoint(CGPoint(x: 0.5, y: 65.69))
        bezierPath.closePath()
        return bezierPath.CGPath
    }
    
    func didMoveToScene() {
        color = SKColor.clearColor()
        let shape = SKShapeNode(path: arrowPath)
        shape.strokeColor = SKColor.grayColor()
        shape.lineWidth = 4
        shape.fillColor = SKColor.whiteColor()
        
        shape.fillTexture = SKTexture(imageNamed: "wood_tinted")
        //shape.fillColor = SKColor.redColor()
        shape
        
        shape.alpha = 0.7
        
        addChild(shape)
        
        let move = SKAction.moveByX(-40, y: 0, duration: 1.0)
        let bounce = SKAction.sequence([
            move, move.reversedAction()
            ])
        let bounceAction = SKAction.repeatAction(bounce, count: 3)
        shape.runAction(bounceAction, completion: {
            self.removeFromParent()
        })
    }
}


