//
//  GameScene.swift
//  ConsolidationProject6
//
//  Created by Wbert Castro on 1/28/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var reloadLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var possibleEnemies = ["skull", "airship", "fish", "smiling"]
    
    let maxBulletCount = 6
    
    var bulletNodes = [SKSpriteNode]()
    
    var bulletCount: Int! {
        didSet {
            drawBullets(bulletCount)
            
            if bulletCount == 0 {
                drawReload()
            }
        }
    }
    
    var gameTimer: Timer?
    
    override func didMove(to view: SKView) {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 15, y: 30)
        scoreLabel.fontSize = 20
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        let background = SKSpriteNode(imageNamed: "background")
        background.zPosition = -1
        background.position = CGPoint(x: 512, y: 384)
        background.size = CGSize(width: 1024, height: 768)
        background.blendMode = .replace
        addChild(background)
        
        bulletCount = maxBulletCount
        
        bulletCount = 5
        
        physicsWorld.gravity = .zero
        
        setTimer(time: 1.5)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for ship in children {
            if ship.position.x > 1300 || ship.position.x < -200 {
                ship.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        if bulletCount == 0 && tappedNodes.contains(reloadLabel) {
            reloadLabel.removeFromParent()
            bulletCount = maxBulletCount
        } else if bulletCount > 0 {
            bulletCount -= 1
            for node in tappedNodes {
                switch node.name {
                case "skull", "fish", "smiling":
                    hitEnemy(node)
                case "airship":
                    hitFriend(node)
                default:
                    continue
                }
            }
        }
    }
    
    @objc func createEnemy() {
        let enemyType = possibleEnemies.randomElement()!
        let enemy = SKSpriteNode(imageNamed: enemyType)
        enemy.name = enemyType
        enemy.size = CGSize(width: 150, height: 100)
        
        
        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.size)
        enemy.physicsBody?.linearDamping = 0
        enemy.physicsBody?.collisionBitMask = 0
        
        let positionY = Int.random(in: 100...600)
        let direction = Bool.random()
        let velocityX = Int.random(in: 200...300)
        
        if (direction) {
            enemy.position = CGPoint(x: -100, y: positionY)
            enemy.physicsBody?.velocity = CGVector(dx: velocityX, dy: 0)
        } else {
            enemy.position = CGPoint(x: 1200, y: positionY)
            enemy.physicsBody?.velocity = CGVector(dx: -velocityX, dy: 0)
            
            enemy.xScale *= -1 // mirror sprite
        }
        
        addChild(enemy)
    }
    
    func drawBullets(_ bullets: Int) {
        for bullet in bulletNodes {
            bullet.removeFromParent()
        }
        
        bulletNodes.removeAll(keepingCapacity: true)
        
        for b in 0..<bullets {
            let bullet = SKSpriteNode(imageNamed: "bullet")
            bullet.zPosition = 2
            bullet.position = CGPoint(x: 1000 - (30 * b), y: 30)
            
            addChild(bullet)
            bulletNodes.append(bullet)
        }
        
        for b in bullets..<maxBulletCount {
            let bullet = SKSpriteNode(imageNamed: "bullet-off")
            bullet.zPosition = 2
            bullet.position = CGPoint(x: 1000 - (30 * b), y: 30)
            
            addChild(bullet)
            bulletNodes.append(bullet)
        }
    }
    
    func drawReload () {
        reloadLabel = SKLabelNode(fontNamed: "Chalkduster")
        reloadLabel.text = "Reload"
        reloadLabel.position = CGPoint(x: 1000, y: 100)
        reloadLabel.horizontalAlignmentMode = .right
        reloadLabel.fontSize = 32
        reloadLabel.zPosition = 1
        
        addChild(reloadLabel)
    }
    
    func hitEnemy(_ node: SKNode) {
        score += 5
        addExplosion(node)
    }
    
    func hitFriend(_ node: SKNode) {
        score -= 20
        addExplosion(node)
    }
    
    func addExplosion(_ node: SKNode) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = node.position
        addChild(explosion)
        node.removeFromParent()
    }
    
    func setTimer(time: TimeInterval) {
        print("created timer with: \(time)")
        if (gameTimer != nil) {
            gameTimer?.invalidate()
        }
        gameTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
}
