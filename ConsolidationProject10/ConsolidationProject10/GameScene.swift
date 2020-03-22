//
//  GameScene.swift
//  ConsolidationProject10
//
//  Created by Wbert Castro on 3/18/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var cards = [CardNode]()
    var correctCards = [CardNode]()
    var prevSelection: CardNode?
    var scoreLabel: SKLabelNode!
    let animals = [
        "antler",
        "bull",
        "bunny",
        "cow",
        "crab-1",
        "crab-2",
        "deer",
        "dog",
        "draco",
        "fishes",
        "goat",
        "horse",
        "lion",
        "monkey",
        "pig",
        "rat",
        "rooster",
        "scorpion",
        "snake",
        "tiger"
    ]
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 160, y: 960)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        newGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        if let cardNode = objects[0].parent as? CardNode {
            if !correctCards.contains(cardNode) && cardNode != prevSelection {
                cardNode.flipCard()
                
                if prevSelection == nil {
                    prevSelection = cardNode
                } else if prevSelection?.imageName == cardNode.imageName {
                    correctCards.append(prevSelection!)
                    correctCards.append(cardNode)
                    score += 2
                    prevSelection = nil
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        [weak self] in
                        self?.prevSelection?.flipCard()
                        cardNode.flipCard()
                        self?.prevSelection = nil
                        self?.score -= 1
                    }
                }
            }
        }
    }
    
    func newGame() {
        createCards()
        resetScore()
    }
    
    func createCards() {
        let selectedAnimals = animals.shuffled()[0..<9]
        let finalList = (selectedAnimals + selectedAnimals).shuffled()
        var i = 0
        for row in 0...5 {
            for column in 0...2 {
                let card = CardNode()
                card.configure(imageName: finalList[i], at: CGPoint(x: 230 + (column * 150), y: 150 + (row * 130)))
                addChild(card)
                cards.append(card)
                i += 1
            }
        }
    }
    
    func resetScore() {
        score = 0
    }
}
