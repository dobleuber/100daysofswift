//
//  DetailViewController.swift
//  ConsolidationProject1
//
//  Created by Wbert Castro on 12/16/19.
//  Copyright © 2019 Wbert Castro. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var countryImageView: UIImageView!
    
    var selectedCountry: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedCountry
        if let flagToLoad = selectedCountry {
            countryImageView.image = UIImage(named: flagToLoad)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(tappedButton))
    }
    
    @objc func tappedButton() {
        guard let image = countryImageView.image?.jpegData(compressionQuality: 0.8) else {
            print("Image not found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [selectedCountry!, image], applicationActivities:  [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
