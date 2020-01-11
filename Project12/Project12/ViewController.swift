//
//  ViewController.swift
//  Project12
//
//  Created by Wbert Castro on 1/10/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        defaults.set(25, forKey: "Age")
        defaults.set(true, forKey: "UserFaceId")
        defaults.set(CGFloat.pi, forKey: "Pi")
        
        defaults.set("Adrian Castro", forKey: "Name")
        defaults.set(Date(), forKey: "LastRun")
        
        let array = ["Hi", "hello"]
        defaults.set(array, forKey: "MyArray")
        
        let dict = ["Name": "Adrian", "Country": "CO"]
        defaults.set(dict, forKey: "Dictionary")
        
        let savedInteger = defaults.integer(forKey: "Age")
        let savedBoolean = defaults.bool(forKey: "UserFaceId")
        let pi = defaults.float(forKey: "Pi")
        
        let name = defaults.string(forKey: "Name") ?? ""
        
        let savedArray = defaults.object(forKey: "MyArray") as? [String] ?? [String]()
        let savedDict = defaults.object(forKey: "Dictionary") as? [String: String] ?? [String: String]()
        
        print(savedInteger)
        print(savedBoolean)
        print(pi)
        print(name)
        print(savedArray)
        print(savedDict)
        
    }


}

