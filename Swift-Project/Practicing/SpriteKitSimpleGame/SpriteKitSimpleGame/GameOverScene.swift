//
//  GameOverScene.swift
//  SpriteKitSimpleGame
//
//  Created by 谢乾坤 on 6/14/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, won:Bool) {
        
        super.init(size: size)
        
        // 1 Sets the background color to white, same as you did for the main scene.
        backgroundColor = SKColor.whiteColor()
        
        // 2 Based on the won parameter, sets the message to either “You Won” or “You Lose”.

        let message = won ? "You Won!" : "You Lose :["
        
        // 3 This is how you display a label of text to the screen with Sprite Kit. As you can see, it’s pretty easy – you just choose your font and set a few parameters.
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        // 4 Finally, this sets up and runs a sequence of two actions. I’ve included them all inline here to show you how handy that is (instead of having to make separate variables for each action). First it waits for 3 seconds, then it uses the runBlock action to run some arbitrary code.
        runAction(SKAction.sequence([
            SKAction.waitForDuration(3.0),
            SKAction.runBlock() {
                // 5 This is how you transition to a new scene in Sprite Kit. First you can pick from a variety of different animated transitions for how you want the scenes to display – you choose a flip transition here that takes 0.5 seconds. Then you create the scene you want to display, and use the presentScene(_:transition:) method on the self.view property.

                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
        
    }
    
    // 6 If you override an initializer on a scene, you must implement the required init(coder:) initializer as well. However this initializer will never be called, so you just add a dummy implementation with a fatalError(_:) for now.
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}