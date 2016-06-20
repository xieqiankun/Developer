//
//  Fall.swift
//  DropCharge
//
//  Created by 谢乾坤 on 6/20/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//
import SpriteKit
import GameplayKit

class Fall: GKState {
    
    
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        print("Fall")
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is Jump.Type || stateClass is Lava.Type
    }
    
    
    
}