//
//  utils.swift
//  ConsolidationProject7
//
//  Created by Wbert Castro on 2/10/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import Foundation

func parseFolder(json: Data) -> [Folder] {
    let decoder = JSONDecoder()
    if let jsonFolder = try? decoder.decode([Folder].self, from: json) {
        return jsonFolder
    }
    
    return [Folder]()
}


func encodeFolder(folders: [Folder]) -> Data? {
    let encoder = JSONEncoder()
    if let jsonString = try? encoder.encode(folders) {
        return jsonString
    }
    
    return nil
}
