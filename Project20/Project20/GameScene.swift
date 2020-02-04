//
//  GameScene.swift
//  Project20
//
//  Created by Wbert Castro on 2/2/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    let lefEdge = -22
    let bottomEdge = -22
    let righEdge = 1024 + 22
    
    var totalLaunches = 10
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 20, y: 50)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }
        
        let path = UIBezierPath()
        
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    
    @objc func launchFireworks() {
        if totalLaunches <= 0 {
            gameTimer?.invalidate()
        }
        
        totalLaunches -= 1
        let movementAmount: CGFloat = 1800
        switch Int.random(in: 0...3) {
        case 0:
            //fire five straight up
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
        case 1:
            //fire five in a fan
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
        case 2:
            //fire five, from left to right
            createFirework(xMovement: movementAmount, x: lefEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: lefEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: lefEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: lefEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: lefEdge, y: bottomEdge)
            
        default:
            //fire five, from right to left
            createFirework(xMovement: -movementAmount, x: righEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: righEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: righEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: righEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: righEdge, y: bottomEdge)
        }
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else {continue}
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else {continue}
                
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 0
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
            
            let waitForDuration = SKAction.wait(forDuration: 0.6)
            let removeFromParent = SKAction.removeFromParent()
            let sequence = SKAction.sequence([waitForDuration, removeFromParent])
            
            emitter.run(sequence)
        }
        
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else {return}
            
            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
}
