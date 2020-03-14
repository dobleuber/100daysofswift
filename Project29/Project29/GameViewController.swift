//
//  GameViewController.swift
//  Project29
//
//  Created by Wbert Castro on 3/7/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene?
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var playerNumber: UILabel!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var windDirection: UILabel!
    
    var scorePlayer1 = 0 {
        didSet {
            scoreLabel.text = "\(scorePlayer1) - \(scorePlayer2)"
        }
    }
    
    var scorePlayer2 = 0 {
        didSet {
            scoreLabel.text = "\(scorePlayer1) - \(scorePlayer2)"
        }
    }
    
    var wind: Int = 0 {
        didSet {
            if wind > 0 {
                windDirection.text = "East: \(wind)"
            } else {
                windDirection.text = "West: \(-wind)"
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        angleChanged(self)
        velocityChanged(self)
        windChanged()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle \(Int(angleSlider.value))"
    }
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity \(Int(velocitySlider.value))"
    }
    @IBAction func launch(_ sender: Any) {
        angleLabel.isHidden = true
        angleSlider.isHidden = true
        
        velocityLabel.isHidden = true
        velocitySlider.isHidden = true
        
        launchButton.isHidden = true
        
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }
        
        angleLabel.isHidden = false
        angleSlider.isHidden = false
        
        velocityLabel.isHidden = false
        velocitySlider.isHidden = false
        
        launchButton.isHidden = false
    }
    
    func windChanged() {
        wind = Int.random(in: -10...10)
        currentGame?.physicsWorld.gravity = CGVector(dx: CGFloat(wind), dy: -9.8)
    }
}
