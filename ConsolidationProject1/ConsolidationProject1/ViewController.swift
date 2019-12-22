//
//  ViewController.swift
//  ConsolidationProject1
//
//  Created by Wbert Castro on 12/16/19.
//  Copyright © 2019 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix(".png") {
                countries.append(item)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath)
        let selectedCountry = countries[indexPath.row]
        cell.textLabel?.text = selectedCountry
        cell.imageView?.image = UIImage(named: selectedCountry)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail")  as? DetailViewController {
           vc.selectedCountry = countries[indexPath.row]
           navigationController?.pushViewController(vc, animated: true)
       }
   }
}

