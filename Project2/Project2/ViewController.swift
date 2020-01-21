//
//  ViewController.swift
//  Project2
//
//  Created by Wbert Castro on 12/12/19.
//  Copyright © 2019 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var highestScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany",
                      "ireland", "italy", "monaco",
                      "nigeria", "poland", "russia",
                      "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showTapped))
        
        let defaults = UserDefaults.standard
        
        highestScore = defaults.integer(forKey: "highestScore")
        
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "Your score is: \(score). Guess the flag for: \(countries[correctAnswer].uppercased())"
    }
    
    func resetGame(action: UIAlertAction) {
        score = 0
        askQuestion()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 8, options: [], animations: {
            sender.imageView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { (finished: Bool) in
            sender.imageView?.transform = .identity
        })
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong, that is the flag of \(countries[sender.tag].capitalized)"
            if score > 0 {
                score -=  1
            }
        }
        
        if score > highestScore {
            title = "You beat the highest score!"
            let defaults = UserDefaults.standard
            
            highestScore = score
            defaults.set(highestScore, forKey: "highestScore")
        }
        
        if (score == 10) {
            let ac = UIAlertController(
                title: "You won!", message: "Your score is \(score)",
                preferredStyle: .alert
            )
            
            ac.addAction(
                UIAlertAction(
                    title: "Play again",
                    style: .default,
                    handler: resetGame)
            )
            
            present(ac, animated: true)
        } else {
        
            let ac = UIAlertController(
                title: title, message: "Your score is \(score)",
                preferredStyle: .alert
            )
            
            ac.addAction(
                UIAlertAction(
                    title: "Continue",
                    style: .default,
                    handler: askQuestion)
            )
            
            present(ac, animated: true)
        }
    }
    
    @objc func showTapped() {
        let ac = UIAlertController(title: "Your score is", message: "\(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(
            title: "OK", style: .default))
        
        present(ac, animated: true)
    }
    
}

