//
//  SeesawNode.swift
//  CatNap
//
//  Created by 谢乾坤 on 6/18/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import SpriteKit


class SeesawNode: SKSpriteNode, CustomNodeEvents {

    
    // there are two ways to impl it
    func didMoveToScene() {
        
        let base = scene!.children.filter({node in node.name == "seasawBase"}).first
        if let base = base {
            
            let pinJoint = SKPhysicsJointPin.jointWithBodyA(physicsBody!, bodyB: base.physicsBody!, anchor: base.position)
            print("I am here")
            print(base.position)
            scene!.physicsWorld.addJoint(pinJoint)
        }
        
        
    }
    
    
    
}
