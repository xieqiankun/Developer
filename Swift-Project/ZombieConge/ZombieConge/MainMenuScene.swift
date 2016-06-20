//
//  MainMenuScene.swift
//  ZombieConge
//
//  Created by 谢乾坤 on 6/16/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    
    override func didMoveToView(view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "MainMenu")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        sceneTapped()
    }
    
    func sceneTapped() {
        
        let scene = GameScene(size: self.size)
        let transition = SKTransition.doorwayWithDuration(1.5)
        scene.scaleMode = scaleMode
        view?.presentScene(scene, transition: transition)
        
    }
    
    
}






