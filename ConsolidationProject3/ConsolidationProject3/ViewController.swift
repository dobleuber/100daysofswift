//
//  ViewController.swift
//  ConsolidationProject3
//
//  Created by Wbert Castro on 1/3/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let alphabet = "abcdefghijklmnopqrstuvwxyz"
    var letterButtons = [UIButton]()
    var selectedButtons = [UIButton]()
    var currentWord: String!
    var rightLetters = [String]()
    var errors = 0 {
        didSet {
            imageView.image = UIImage(named: hangmanImages[errors])
        }
    }
    let MaxErrorCount = 6
    
    var hangmanImages = [String]()

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var selectedWord: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawButtons()
        getWord()
        loadHangmanImages()
    }
    
    func drawButtons () {
        let size = 60
        let initialX = 90
        let initialY = 400
        
        for (i, letter) in alphabet.enumerated() {
            let strLetter = String(letter)
            
            let letterButton = UIButton(type: .system)
            letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
            letterButton.setTitle(strLetter, for: .normal)
            
            letterButton.layer.borderWidth = 1
            letterButton.layer.borderColor = UIColor.lightGray.cgColor
            
            letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            
            let column = i % 4
            let row = i / 4
            
            let frame = CGRect(x: initialX + column * size + 5, y: initialY + row * size + 5, width: size - 5, height: size - 5)
            
            letterButton.frame = frame
            
            letterButtons.append(letterButton)
            view.addSubview(letterButton)
        }
    }
    
    func getWord() {
        let getKeyUrl = "https://random-word-api.herokuapp.com/key?"
        
        DispatchQueue.global(qos: .background).async {
            [weak self] in
            if let keyUrl = URL(string: getKeyUrl) {
                if let key = try? String(contentsOf: keyUrl) {
                    let getWordUrl = "https://random-word-api.herokuapp.com/word?key=\(key)&number=1"
                    if let url = URL(string: getWordUrl) {
                        if let word = try? String(contentsOf: url) {
                            self?.parse(word)
                        }
                    }
                }
            }
        }
    }
    
    func parse(_ resultString: String) {
        let data = Data(resultString.utf8)
        if let words = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] {
            DispatchQueue.main.async {
                [weak self] in
                self?.currentWord = words[0]
                var hiddenWord = ""
                for _ in words[0] {
                    hiddenWord += "?"
                }
                self?.selectedWord.text = hiddenWord
            }
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else {
            return
        }
        
        var hiddenWord = ""
        
        if currentWord.contains(buttonTitle) {
            rightLetters.append(buttonTitle)
            for letterChar in currentWord {
                let letter = String(letterChar)
                if rightLetters.contains(letter) {
                    hiddenWord += letter
                } else {
                    hiddenWord += "?"
                }
            }
            
            selectedWord.text = hiddenWord
        } else {
            errors += 1
        }
        
        updateGameStatus()
        
        selectedButtons.append(sender)
        sender.isHidden = true
    }
    
    func loadHangmanImages () {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path).sorted()
        for item in items {
            if item.hasSuffix(".png") {
                hangmanImages.append(item)
            }
        }
    }
    
    func updateGameStatus () {
        if (errors == MaxErrorCount) {
            let ac = UIAlertController(title: "You lose!", message: "The word was \"\(currentWord!)\". Try again?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: restarGame))
            present(ac, animated: true)
            return
        }
        
        if !selectedWord.text!.contains("?") {
            let ac = UIAlertController(title: "Congratulations!", message: "You won the game. Do you want to play again?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: restarGame))
            present(ac, animated: true)
            return
        }
    }
    
    func restarGame (action: UIAlertAction) {
        getWord()
        for button in selectedButtons {
            button.isHidden = false
        }
        
        selectedButtons.removeAll(keepingCapacity: true)
        
        errors = 0
        rightLetters.removeAll()
    }
}

