//
//  ViewController.swift
//  ConsolidationProject8
//
//  Created by Wbert Castro on 2/20/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var testLabel: UILabel!
    
    var wasAnimated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (-6).times {
            print("hi!!")
        }
    }

    @IBAction func clickButton(_ sender: UIButton) {
        if (wasAnimated) {
            testLabel.bounceIn()
        } else {
            testLabel.bounceOut(duration: 2)
        }
        wasAnimated = !wasAnimated
    }
    
}

