//
//  GameScene.swift
//  10_FallingBoxes
//
//  Created by Jonas Kübler on 16.09.19.
//  Copyright © 2019 Jonas Kübler. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        
        // Set background as new sprite node and define position to center
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // Init physicsbode with edge of the frame
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        // add slots between bouncers
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
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
        // contactTestBitMark tells you which collision you want to know about
        // collisionBitMask is everything it bounces off
        ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
        ball.position = location
        ball.name = "ball"
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
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        // gives a rectangle physics body the size of the slotBase
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        // make glow soin slightly
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    // SKNode is parent class of SKSpriteNode
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
        } else if object.name == "bad" {
            destroy(ball: ball)
        }
    }
    
    func destroy(ball: SKNode) {
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // check if node was not destroyed by previous collision
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
    
}
