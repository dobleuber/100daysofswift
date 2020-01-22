//
//  Country.swift
//  ConsolidationProject5
//
//  Created by Wbert Castro on 1/21/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import Foundation

struct Country: Codable {
    var name: String
    var capital: String
    var region: String
    var population: Int
    var flag: String
    var area: Float?
}
