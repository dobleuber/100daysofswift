//
//  GameScene.swift
//  Project14
//
//  Created by Wbert Castro on 1/17/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    var playAgain: SKLabelNode!
    var finalScore: SKLabelNode!
    var gameOverSN: SKSpriteNode!
    
    var popupTime = 0.85
    var numRounds = 0
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0..<5 {
            createSlot(at: CGPoint(x: 100 + (i * 170), y: 410))
            createSlot(at: CGPoint(x: 100 + (i * 170), y: 230))
        }
        
        for i in 0..<4 {
            createSlot(at: CGPoint(x: 180 + (i * 170), y: 320))
            createSlot(at: CGPoint(x: 180 + (i * 170), y: 140))
        }
        
        newGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        if playAgain != nil && tappedNodes.contains(playAgain) {
            newGame()
        } else {
            for node in tappedNodes {
                guard let whackSlot = node.parent?.parent as? WhackSlot else {continue}
                if !whackSlot.isVisible || whackSlot.isHit {
                    continue
                }
                
                whackSlot.hit()
                
                if node.name == "charFriend" {
                    
                    score -= 5
                    
                    run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                } else if node.name == "charEnemy" {
                    whackSlot.charNode.xScale = 0.85
                    whackSlot.charNode.yScale = 0.85
                    
                    score += 1
                    
                    run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                }
            }
        }
    }
 
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        numRounds += 1
        
        if (numRounds >= 30) {
            gameOver()
            return
        }
        
        popupTime *= 0.991
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 4 {
            slots[1].show(hideTime: popupTime)
        }
        
        if Int.random(in: 0...12) > 8 {
            slots[2].show(hideTime: popupTime)
        }
        
        if Int.random(in: 0...12) > 10 {
            slots[3].show(hideTime: popupTime)
        }
        
        if Int.random(in: 0...12) > 11 {
            slots[4].show(hideTime: popupTime)
        }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2.0
        
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + delay) {
            [weak self] in
            self?.createEnemy()
        }
    }
    
    func gameOver() {
        for slot in slots {
            slot.hide()
        }
        
        gameOverSN = SKSpriteNode(imageNamed: "gameOver")
        gameOverSN.position = CGPoint(x: 512, y: 384)
        gameOverSN.zPosition = 1
        addChild(gameOverSN)
        
        finalScore = SKLabelNode(fontNamed: "Chalkduster")
        finalScore.text = "Final Score: \(score)"
        finalScore.position = CGPoint(x: 512, y: 284)
        finalScore.horizontalAlignmentMode = .center
        finalScore.fontSize = 48
        finalScore.zPosition = 1
        
        addChild(finalScore)
        
        playAgain = SKLabelNode(fontNamed: "Chalkduster")
        playAgain.text = "Play Again?"
        playAgain.position = CGPoint(x: 512, y: 184)
        playAgain.horizontalAlignmentMode = .center
        playAgain.fontSize = 32
        playAgain.zPosition = 1
        
        addChild(playAgain)
        
        run(SKAction.playSoundFileNamed("gameOver.caf", waitForCompletion: false))
    }
    
    func newGame () {
        score = 0
        popupTime = 0.85
        numRounds = 0
        
        if (gameOverSN != nil) {
            gameOverSN.removeFromParent()
        }
        
        if (finalScore != nil) {
            finalScore.removeFromParent()
        }
        
        if (playAgain != nil) {
            playAgain.removeFromParent()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
            [weak self] in
            self?.createEnemy()
        }
    }
}
