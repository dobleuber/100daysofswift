//
//  Folder.swift
//  ConsolidationProject7
//
//  Created by Wbert Castro on 2/8/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import Foundation

class Folder: Codable {
    var name: String
    var notes: [Note]
    
    init(name: String, notes: [Note]) {
        self.name = name
        self.notes = notes
    }
}
