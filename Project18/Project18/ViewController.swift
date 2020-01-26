//
//  ViewController.swift
//  Project18
//
//  Created by Wbert Castro on 1/26/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("I am inside the viewDidLoad() method")
        print(1,2,3,4,5, separator: "-", terminator: "")
        print("Finish")
        
        assert(1 == 1, "Math is ok")
        
        for i in 1...100 {
            print("Got number \(i)")
        }
        
    }
}

