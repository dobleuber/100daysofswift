//
//  ViewController.swift
//  ConsolidationProject2
//
//  Created by Wbert Castro on 12/25/19.
//  Copyright © 2019 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddItemDialog))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearShoppingList))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        
        cell.textLabel?.text = shoppingList[indexPath.row]
        
        return cell
    }
    
    @objc func showAddItemDialog() {
        let ac = UIAlertController(title: "Add item", message: "What would you like to add", preferredStyle: .alert)
        
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] action in
            guard let newItem = ac?.textFields?[0].text else { return }
            self?.addItem(newItem)
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    func addItem(_ item: String) {
        shoppingList.append(item)
        let indexPath = IndexPath(item: shoppingList.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func clearShoppingList() {
        shoppingList.removeAll()
        tableView.reloadData()
    }
}

