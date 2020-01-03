//
//  ViewController.swift
//  Project7
//
//  Created by Wbert Castro on 12/26/19.
//  Copyright © 2019 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filterButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterPetitions))
        let clearButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(clearFilter))
        let aboutButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showCredits))
        
        navigationItem.rightBarButtonItems = [filterButton, clearButton, aboutButton]
        
        fetchJson()
    }
    
    func fetchJson() {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self?.parse(json: data)
                    return
                }
            }
            
            self?.showError()
        }
    }
    
    func showError() {
        DispatchQueue.main.async {
            [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            self?.present(ac, animated: true)
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
        
            filteredPetitions = petitions
            DispatchQueue.main.async {
            [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = filteredPetitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "This date was provided for We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
    }
    
    @objc func filterPetitions () {
        let ac = UIAlertController(title: "Filter Petitions", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "OK", style: .default) { [unowned ac] _ in
            let filter = ac.textFields![0]
            
            if filter.text!.isEmpty { return }
            let loweredText = filter.text!.lowercased()
            
            DispatchQueue.global(qos: .background).async {
                [weak self] in
                self?.filteredPetitions = self!.petitions.filter {
                    $0.body.lowercased().contains(loweredText)
                }
                
                DispatchQueue.main.async {
                    [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    @objc func clearFilter() {
        filteredPetitions = petitions
        tableView.reloadData()
    }
}

