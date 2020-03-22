//
//  CardNode.swift
//  ConsolidationProject10
//
//  Created by Wbert Castro on 3/21/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import SpriteKit

class CardNode: SKNode {
    var imageName: String?
    var isFlipped = false
    var animalNode: SKSpriteNode!
    var background: SKShapeNode!
    func configure(imageName: String, at position: CGPoint) {
        background = SKShapeNode(rectOf: CGSize(width: 140, height: 120))
        background.fillColor = .blue
        name = "card"
        addChild(background)
        self.imageName = imageName
        
        self.position = position
    }
    
    func flipCard() {
        let sequence: SKAction!
        if isFlipped {
            let flip = SKAction.scaleX(to: -1, duration: 0.5)
            setScale(1.0)
            let remove = SKAction.run {
                self.background.fillColor = .blue
                self.animalNode?.removeFromParent()
            }
            sequence = SKAction.sequence([remove, flip])
        } else {
            let flip = SKAction.scaleX(to: -1, duration: 0.5)
            setScale(1.0)
            let create = SKAction.run {
                self.background.fillColor = .white
                self.animalNode = SKSpriteNode(imageNamed: self.imageName!)
                self.addChild(self.animalNode)
            }
            sequence = SKAction.sequence([flip, create])
        }
        
        isFlipped = !isFlipped
        
        run(sequence)
    }
}
