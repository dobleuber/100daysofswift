//
//  GameScene.swift
//  Project26
//
//  Created by Wbert Castro on 2/24/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import CoreMotion
import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case portal = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager?
    var isGameOver = false
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var portals = [SKSpriteNode]()
    
    var currentItems = [SKSpriteNode]()
    
    var currentLevel = 1
    
    override func didMove(to view: SKView) {
        loadBackground()
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        score = 0
        
        loadLevel()
        createPlayer()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    func loadBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    func loadLevel() {
        guard let levelUrl = Bundle.main.url(forResource: "level\(currentLevel)", withExtension: "txt") else {
            fatalError("Could not find level1.txt in the app bundle.")
        }
        
        guard let levelString = try? String(contentsOf: levelUrl) else {
            fatalError("Could not load level1.txt from the app bundle.")
        }
        
        let lines = levelString.components(separatedBy: "\n").reversed()
        
        for (row, line) in lines.enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                switch letter {
                case "x":
                    createWall(at: position)
                case "v":
                    createVortex(at: position)
                case "s":
                    createStar(at: position)
                case "f":
                    createGoal(at: position)
                case "p":
                    createPortal(at: position)
                case " ":
                    continue
                default:
                    fatalError("Unknown level letter: \(letter)")
                }
            }
        }
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue
            | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
            | CollisionTypes.portal.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        
        player.zPosition = 1
        
        addChild(player)
    }
    
    func createWall(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
        currentItems.append(node)
    }
    
    func createVortex(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.isDynamic = false
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
        currentItems.append(node)
    }
    
    func createPortal(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "portal"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: -.pi, duration: 1)))
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = CollisionTypes.portal.rawValue
        node.physicsBody?.isDynamic = false
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
        portals.append(node)
    }
    
    func createStar(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.position = position
        node.name = "star"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
        currentItems.append(node)
    }
    
    func createGoal(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "finish")
        node.position = position
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
        currentItems.append(node)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else {return}
        #if targetEnvironment(simulator)
        if let lastTouchPosition  = lastTouchPosition {
            let diff = CGPoint(
                x: lastTouchPosition.x - player.position.x,
                y: lastTouchPosition.y - player.position.y
            )
            
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA == player {
            playerCollide(with: nodeB)
        } else {
            playerCollide(with: nodeA)
        }
    }
    
    func playerCollide(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(by: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) {
                [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "portal" {
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(by: 0.0001, duration: 0.25)
            let scaleOut = SKAction.reversed(scale)
            let sequence = SKAction.sequence([move, scale])
            
            player.run(sequence) {
                [weak self] in
                
                guard let portals = self?.portals else {return}
                
                if self?.portals[0] == node {
                    self?.player.position = portals[1].position
                } else {
                    self?.player.position = portals[0].position
                }
                
                for node in portals.reversed() {
                    node.removeFromParent()
                }
                
                self?.player.run(scaleOut())
            }
            
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            // next level
            loadNewLevel()
        }
    }
    
    func loadNewLevel() {
        for node in currentItems.reversed() {
            node.removeFromParent()
        }
        
        for node in portals.reversed() {
            node.removeFromParent()
        }
        
        player.removeFromParent()
        currentLevel += 1
        loadLevel()
        createPlayer()
    }
}
