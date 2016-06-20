//
//  DiscoBallNode.swift
//  CatNap
//
//  Created by 谢乾坤 on 6/18/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import SpriteKit
import AVFoundation

class DiscoBallNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
    
    private var player: AVPlayer!
    private var video: SKVideoNode!
    
    static private(set) var isDiscoTime = false
    
    private var isDiscoTime: Bool = false {
        didSet {
            DiscoBallNode.isDiscoTime = isDiscoTime
            video.hidden = !isDiscoTime
            if isDiscoTime {
                video.play()
                runAction(spinAction)
            } else {
                video.pause()
                removeAllActions()
            }
            SKTAudio.sharedInstance().playBackgroundMusic(
                isDiscoTime ? "disco-sound.m4a" : "backgroundMusic.mp3"
            )
            if isDiscoTime {
                video.runAction(SKAction.waitForDuration(5.0), completion: {
                    self.isDiscoTime = false
                })
            }
        }
    }
    
    private let spinAction = SKAction.repeatActionForever(
        SKAction.animateWithTextures([
            SKTexture(imageNamed: "discoball1"),
            SKTexture(imageNamed: "discoball2"),
            SKTexture(imageNamed: "discoball3")
            ], timePerFrame: 0.2))
    
    
    func didMoveToScene() {
        userInteractionEnabled = true
        
        let fileUrl = NSBundle.mainBundle().URLForResource("discolights-loop", withExtension: "mov")!
        player = AVPlayer(URL: fileUrl)
        video = SKVideoNode(AVPlayer: player)
        video.size = scene!.size
        video.position = CGPoint(
            x: CGRectGetMidX(scene!.frame),
            y: CGRectGetMidY(scene!.frame))
        video.zPosition = -1
        video.alpha = 0.75
        scene!.addChild(video)
        video.hidden = true
        video.pause()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DiscoBallNode.didReachEndOfVideo),name:AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        
    }
    
    
    func interact() {
        if !isDiscoTime {
            isDiscoTime = true
        }
    }
    
    func didReachEndOfVideo() {
        //print("rewind!")
        player.currentItem!.seekToTime(kCMTimeZero)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        interact()
    }
    
}














