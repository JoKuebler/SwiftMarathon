//
//  GameScene.swift
//  10_FallingBoxes
//
//  Created by Jonas Kübler on 16.09.19.
//  Copyright © 2019 Jonas Kübler. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        // Set background as new sprite node and define position to center
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // Init physicsbode with edge of the frame
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        // add bouncers across the screen
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
    }
    
    // Define what happens on first touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // get first touch and store location
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Create box as new sprite node whereever user touched
        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        // Bounciness from 0 to 1 (superbouncy)
        ball.physicsBody?.restitution = 0.4
        ball.position = location
        addChild(ball)
        
    }
    
    
    func makeBouncer(at position: CGPoint) {
        
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        
        // Decide if bouncer is fixed or dynamically moveable
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
        
    }
    
}
