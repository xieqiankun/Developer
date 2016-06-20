//
//  GameScene.swift
//  DropCharge
//
//  Created by 谢乾坤 on 6/20/16.
//  Copyright (c) 2016 QiankunXie. All rights reserved.
//

import SpriteKit
import CoreMotion
import GameplayKit

struct PhysicsCategory {
    
    static let None: UInt32                 = 0 //0
    static let Player: UInt32               = 0b1 //1
    static let PlatformNormal: UInt32       = 0b10 //2
    static let PlatformBreakable: UInt32    = 0b100 //4
    static let CoinNormal: UInt32           = 0b1000 //8
    static let CoinSpecial: UInt32          = 0b10000 //16
    static let Edges: UInt32                = 0b100000 //16
    
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //var isPlaying: Bool = false
    var lives = 3
    
    let motionManager = CMMotionManager()
    var xAcceleration = CGFloat(0)
    
    // MARK: - Properties
    var bgNode = SKNode()
    var fgNode = SKNode()
    var background: SKNode!
    var backHeight: CGFloat = 0.0
    var player: SKSpriteNode!
    
    var platform5Across: SKSpriteNode!
    var coinArrow: SKSpriteNode!
    var platformArrow: SKSpriteNode!
    var platformDiagonal: SKSpriteNode!
    var breakArrow: SKSpriteNode!
    var break5Across: SKSpriteNode!
    var breakDiagonal: SKSpriteNode!
    var coin5Across: SKSpriteNode!
    var coinDiagonal: SKSpriteNode!
    var coinCross: SKSpriteNode!
    var coinS5Across: SKSpriteNode!
    var coinSDiagonal: SKSpriteNode!
    var coinSCross: SKSpriteNode!
    var coinSArrow: SKSpriteNode!
    
    
    var lastItemPosition = CGPointZero
    var lastItemHeight: CGFloat = 0.0
    var levelY: CGFloat = 0.0
    
    let cameraNode = SKCameraNode()
    var lava: SKSpriteNode!
    
    var lastUpdateTimeInterval: NSTimeInterval = 0
    var deltaTime: NSTimeInterval = 0
    
    //states
    lazy var gameState: GKStateMachine = GKStateMachine(states: [WaitingForTap(scene: self), WaitingForBomb(scene: self),Playing(scene: self), GameOver(scene: self)])
    
    lazy var playerState: GKStateMachine = GKStateMachine(states: [Idle(scene:self), Jump(scene:self), Fall(scene:self), Lava(scene:self), Dead(scene:self)])
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        setupNodes()
        setupLevel()
        //setupPlayer()
        
        setupCoreMotion()
        setCameraPosition(CGPoint(x: size.width/2, y: size.height/2))
        
        gameState.enterState(WaitingForTap)
        playerState.enterState(Idle)
    }
    
    override func update(currentTime: CFTimeInterval) {
        if lastUpdateTimeInterval > 0 {
            deltaTime = currentTime - lastUpdateTimeInterval
        } else {
            deltaTime = 0
        }
        lastUpdateTimeInterval = currentTime
        if paused { return }
        gameState.updateWithDeltaTime(deltaTime)
    }
    
    
    
    func setupNodes() {
        let worldNode = childNodeWithName("World")!
        bgNode = worldNode.childNodeWithName("Background")!
        background = bgNode.childNodeWithName("Overlay")!.copy()
            as! SKNode
        backHeight = background.calculateAccumulatedFrame().height
        fgNode = worldNode.childNodeWithName("Foreground")!
        player = fgNode.childNodeWithName("Player") as! SKSpriteNode
        fgNode.childNodeWithName("Bomb")?.runAction(SKAction.hide())
        
        platformArrow = loadOverlayNode("PlatformArrow")
        platform5Across = loadOverlayNode("Platform5Across")
        platformDiagonal = loadOverlayNode("PlatformDiagonal")
        breakArrow = loadOverlayNode("BreakArrow")
        break5Across = loadOverlayNode("Break5Across")
        breakDiagonal = loadOverlayNode("BreakDiagonal")
        coin5Across = loadOverlayNode("Coin5Across")
        coinDiagonal = loadOverlayNode("CoinDiagonal")
        coinCross = loadOverlayNode("CoinCross")
        coinArrow = loadOverlayNode("CoinArrow")
        coinS5Across = loadOverlayNode("CoinS5Across")
        coinSDiagonal = loadOverlayNode("CoinSDiagonal")
        coinSCross = loadOverlayNode("CoinSCross")
        coinSArrow = loadOverlayNode("CoinSArrow")
        
        
        lava = fgNode.childNodeWithName("Lava") as! SKSpriteNode
        
        addChild(cameraNode)
        camera = cameraNode
        
    }
    
    func setupLevel() {
        // Place initial platform
        // use .copy() to avoid loading .sks agian and again
        let initialPlatform = platform5Across.copy() as! SKSpriteNode
        var itemPosition = player.position
        itemPosition.y = player.position.y - ((player.size.height * 0.5) + (initialPlatform.size.height * 0.20))
        initialPlatform.position = itemPosition
        fgNode.addChild(initialPlatform)
        lastItemPosition = itemPosition
        lastItemHeight = initialPlatform.size.height / 2.0
        
        levelY = bgNode.childNodeWithName("Overlay")!.position.y + backHeight
        while lastItemPosition.y < levelY {
            addRandomOverlayNode()
        }
    }
    
    func setupPlayer() {
        player.physicsBody = SKPhysicsBody(circleOfRadius:
            player.size.width * 0.3)
        player.physicsBody!.dynamic = false
        player.physicsBody!.allowsRotation = false
        player.physicsBody!.categoryBitMask = PhysicsCategory.Player
        player.physicsBody!.collisionBitMask = 0
    }
    
    func setupCoreMotion() {
        motionManager.accelerometerUpdateInterval = 0.2
        let queue = NSOperationQueue()
        motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
            {
                accelerometerData, error in
                guard let accelerometerData = accelerometerData else {
                    return
                }
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = (CGFloat(acceleration.x) * 0.75) + (self.xAcceleration * 0.25)
        })
    }
    
    // MARK: Platform/Coin overlay nodes.
    func loadOverlayNode(fileName: String) -> SKSpriteNode {
        let overlayScene = SKScene(fileNamed: fileName)!
        let contentTemplateNode =
            overlayScene.childNodeWithName("Overlay")
        return contentTemplateNode as! SKSpriteNode
    }
    
    func createOverlayNode(nodeType: SKSpriteNode, flipX: Bool) {
        let platform = nodeType.copy() as! SKSpriteNode
        lastItemPosition.y = lastItemPosition.y +
            (lastItemHeight + (platform.size.height / 2.0))
        lastItemHeight = platform.size.height / 2.0
        platform.position = lastItemPosition
        if flipX == true {
            platform.xScale = -1.0
        }
        fgNode.addChild(platform)
    }
    
    func addRandomOverlayNode() {
        let overlaySprite: SKSpriteNode!
        var flipH = false
        let platformPercentage = 60
        
        if Int.random(min: 1, max: 100) <= platformPercentage {
            if Int.random(min: 1, max: 100) <= 75 {
                // Create standard platforms 75%
                switch Int.random(min: 0, max: 3) {
                case 0:
                    overlaySprite = platformArrow
                case 1:
                    overlaySprite = platform5Across
                case 2:
                    overlaySprite = platformDiagonal
                case 3:
                    overlaySprite = platformDiagonal
                    flipH = true
                default:
                    overlaySprite = platformArrow
                }
            } else {
                // Create breakable platforms 25%
                switch Int.random(min: 0, max: 3) {
                case 0:
                    overlaySprite = breakArrow
                case 1:
                    overlaySprite = break5Across
                case 2:
                    overlaySprite = breakDiagonal
                case 3:
                    overlaySprite = breakDiagonal
                    flipH = true
                default:
                    overlaySprite = breakArrow
                }
            }
        } else {
            if Int.random(min: 1, max: 100) <= 75 {
                // Create standard coins 75%
                switch Int.random(min: 0, max: 4) {
                case 0:
                    overlaySprite = coinArrow
                case 1:
                    overlaySprite = coin5Across
                case 2:
                    overlaySprite = coinDiagonal
                case 3:
                    overlaySprite = coinDiagonal
                    flipH = true
                case 4:
                    overlaySprite = coinCross
                default:
                    overlaySprite = coinArrow
                }
            } else {
                // Create special coins 25%
                switch Int.random(min: 0, max: 4) {
                case 0:
                    overlaySprite = coinSArrow
                case 1:
                    overlaySprite = coinS5Across
                case 2:
                    overlaySprite = coinSDiagonal
                case 3:
                    overlaySprite = coinSDiagonal
                    flipH = true
                case 4:
                    overlaySprite = coinSCross
                default:
                    overlaySprite = coinSArrow
                }
            }
        }
        
        createOverlayNode(overlaySprite, flipX: flipH)
    }

    
    func createBackgroundNode() {
        let backNode = background.copy() as! SKNode
        backNode.position = CGPoint(x: 0.0, y: levelY)
        bgNode.addChild(backNode)
        levelY += backHeight
    }
    
    
    // MARK: - Events
    override func touchesBegan(touches: Set<UITouch>, withEvent event:
        UIEvent?) {
        // use game state machine
        switch gameState.currentState {
        case is WaitingForTap:
            gameState.enterState(WaitingForBomb)
            self.runAction(SKAction.waitForDuration(2.0),
                           completion:{self.gameState.enterState(Playing)})
        case is GameOver:
            let newScene = GameScene(fileNamed:"GameScene")
            newScene!.scaleMode = .AspectFill
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            self.view?.presentScene(newScene!, transition: reveal)
            
        default:
            break
        }
    }
    
//    func bombDrop() {
//        let scaleUp = SKAction.scaleTo(1.25, duration: 0.25)
//        let scaleDown = SKAction.scaleTo(1.0, duration: 0.25)
//        let sequence = SKAction.sequence([scaleUp, scaleDown])
//        let repeatSeq = SKAction.repeatActionForever(sequence)
//        fgNode.childNodeWithName("Bomb")!.runAction(SKAction.unhide())
//        fgNode.childNodeWithName("Bomb")!.runAction(repeatSeq)
//        runAction(SKAction.sequence([
//            SKAction.waitForDuration(2.0),
//            SKAction.runBlock(startGame)
//            ]))
//    }
//    
//    func startGame() {
//        fgNode.childNodeWithName("Title")!.removeFromParent()
//        fgNode.childNodeWithName("Bomb")!.removeFromParent()
//        isPlaying = true
//        player.physicsBody!.dynamic = true
//        superBoostPlayer()
//    }
    
    func setPlayerVelocity(amount:CGFloat) {
        let gain: CGFloat = 2.5
        player.physicsBody!.velocity.dy =
            max(player.physicsBody!.velocity.dy, amount * gain)
    }
    func jumpPlayer() {
        setPlayerVelocity(650)
    }
    func boostPlayer() {
        setPlayerVelocity(1200)
    }
    func superBoostPlayer() {
        setPlayerVelocity(1700)
    }
    
    // MARK: - Contacts
    func didBeginContact(contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        switch other.categoryBitMask {
        case PhysicsCategory.CoinNormal:
            if let coin = other.node as? SKSpriteNode {
                coin.removeFromParent()
                jumpPlayer()
            }
        case PhysicsCategory.CoinSpecial:
            if let coin = other.node as? SKSpriteNode {
                coin.removeFromParent()
                boostPlayer()
            }
        case PhysicsCategory.PlatformNormal:
            if let _ = other.node as? SKSpriteNode {
                if player.physicsBody!.velocity.dy < 0 {
                    jumpPlayer()
                }
            }
        case PhysicsCategory.PlatformBreakable:
            if let platform = other.node as? SKSpriteNode {
                if player.physicsBody!.velocity.dy < 0 {
                    platform.removeFromParent()
                    jumpPlayer()
                }
            }
        default:
            break;
        }
    }

    
    func updatePlayer() {
        // Set velocity based on core motion
        player.physicsBody?.velocity.dx = xAcceleration * 1000.0
        // Wrap player around edges of screen
        var playerPosition = convertPoint(player.position,
                                          fromNode: fgNode)
        if playerPosition.x < -player.size.width/2 {
            playerPosition = convertPoint(CGPoint(x: size.width +
                player.size.width/2, y: 0.0), toNode: fgNode)
            player.position.x = playerPosition.x
        }
        else if playerPosition.x > size.width + player.size.width/2 {
            playerPosition = convertPoint(CGPoint(x:
                -player.size.width/2, y: 0.0), toNode: fgNode)
            player.position.x = playerPosition.x
        }
        
        //update status
        if player.physicsBody?.velocity.dy < 0 {
            playerState.enterState(Fall)
        } else {
            playerState.enterState(Jump)
        }
    }
    
    // MARK: - Camera
    func overlapAmount() -> CGFloat {
        guard let view = self.view else {
            return 0 }
        let scale = view.bounds.size.height / self.size.height
        let scaledWidth = self.size.width * scale
        let scaledOverlap = scaledWidth - view.bounds.size.width
        return scaledOverlap / scale
    }
    func getCameraPosition() -> CGPoint {
        return CGPoint(
            x: cameraNode.position.x + overlapAmount()/2,
            y: cameraNode.position.y)
    }
    func setCameraPosition(position: CGPoint) {
        cameraNode.position = CGPoint(
            x: position.x - overlapAmount()/2,
            y: position.y)
    }
    func updateCamera() {
        // 1
        let cameraTarget = convertPoint(player.position,
                                        fromNode: fgNode)
        // 2
        var targetPosition = CGPoint(x: getCameraPosition().x,
                                     y: cameraTarget.y - (scene!.view!.bounds.height * 0.40))
        //print(targetPosition)
        let lavaPos = convertPoint(lava.position, fromNode: fgNode)
        targetPosition.y = max(targetPosition.y, lavaPos.y)
        // 3
        let diff = targetPosition - getCameraPosition()
        // 4
        let lerpValue = CGFloat(0.2)
        let lerpDiff = diff * lerpValue
        let newPosition = getCameraPosition() + lerpDiff
        // 5
        setCameraPosition(CGPoint(x: size.width/2, y: newPosition.y))
    }
    
    func updateLava(dt: NSTimeInterval) {
        // 1
        let lowerLeft = CGPoint(x: 0, y: cameraNode.position.y -
            (size.height / 2))
        // 2
        let visibleMinYFg = scene!.convertPoint(lowerLeft, toNode:
            fgNode).y
        // 3
        let lavaVelocity = CGPoint(x: 0, y: 120)
        let lavaStep = lavaVelocity * CGFloat(dt)
        var newPosition = lava.position + lavaStep
        // 4
        newPosition.y = max(newPosition.y, (visibleMinYFg - 125.0))
        // 5
        lava.position = newPosition
    }
    
    func updateCollisionLava() {
        if player.position.y < lava.position.y + 90 {
            playerState.enterState(Lava)
            if lives <= 0 {
                gameState.enterState(GameOver)
                playerState.enterState(Dead)
            }
        }
    }
    
    func updateLevel() {
        let cameraPos = getCameraPosition()
        if cameraPos.y > levelY - (size.height * 0.55) {
            createBackgroundNode()
            while lastItemPosition.y < levelY {
                addRandomOverlayNode()
            }
        }
    }
}










