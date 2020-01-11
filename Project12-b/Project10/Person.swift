//
//  Person.swift
//  Project10
//
//  Created by Wbert Castro on 1/5/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
