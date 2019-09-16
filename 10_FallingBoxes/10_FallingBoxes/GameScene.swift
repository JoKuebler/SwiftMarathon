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
       
    }
    
    // Define what happens on first touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // get first touch and store location
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Create box as new sprite node whereever user touched
        let box = SKSpriteNode(color: .red, size: CGSize(width: 64, height: 64))
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
        box.position = location
        addChild(box)
        
    }
}
