//
//  CountryViewController.swift
//  Project16
//
//  Created by Wbert Castro on 1/23/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import WebKit
import UIKit

class CountryViewController: UIViewController {
    let webView = WKWebView()
    var url: String!
    override func viewDidLoad() {
        self.view = webView
        
        if let url = URL(string: self.url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

}
