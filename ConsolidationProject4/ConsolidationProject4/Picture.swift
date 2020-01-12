//
//  Picture.swift
//  ConsolidationProject4
//
//  Created by Wbert Castro on 1/12/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import Foundation

class Picture: Codable {
    var caption: String!
    var fileName: String!
    
    init(caption: String, fileName: String) {
        self.caption = caption
        self.fileName = fileName
    }
}
