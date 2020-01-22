//
//  DetailViewController.swift
//  ConsolidationProject5
//
//  Created by Wbert Castro on 1/21/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import WebKit
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var capitalLabel: UILabel!
    @IBOutlet var regionLabel: UILabel!
    @IBOutlet var populationLabel: UILabel!
    
    var country: Country!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = country.name
        capitalLabel.text = country.capital
        regionLabel.text = country.region
        populationLabel.text = "\(country.population)"
    }
}
