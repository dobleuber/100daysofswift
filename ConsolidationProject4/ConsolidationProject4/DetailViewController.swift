//
//  DetailViewController.swift
//  ConsolidationProject4
//
//  Created by Wbert Castro on 1/12/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var pictureFilePath: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(contentsOfFile: pictureFilePath)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
