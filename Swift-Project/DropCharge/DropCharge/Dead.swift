//
//  Dead.swift
//  DropCharge
//
//  Created by 谢乾坤 on 6/20/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import SpriteKit
import GameplayKit

class Dead: GKState {
    
    
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        print("Dead")
        if previousState is Lava {
            scene.physicsWorld.contactDelegate = nil
            scene.player.physicsBody?.dynamic = false
            
            let moveUpAction = SKAction.moveByX(0, y: scene.size.height/2, duration: 0.5)
            moveUpAction.timingMode = .EaseOut
            let moveDownAction = SKAction.moveByX(0, y: -(scene.size.height * 1.5), duration: 1.0)
            moveDownAction.timingMode = .EaseIn
            let sequence = SKAction.sequence([moveUpAction, moveDownAction])
            scene.player.runAction(sequence)
        }
    }
    
}