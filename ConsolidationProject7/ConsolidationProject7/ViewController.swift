//
//  ViewController.swift
//  ConsolidationProject7
//
//  Created by Wbert Castro on 2/8/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var folders = [Folder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFolder))
        
//        let userDefaults = UserDefaults.standard
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folder", for: indexPath)
        
        let folder = folders[indexPath.row]
        
        cell.textLabel?.text = folder.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "folder") as? FolderViewController else {return}
        
        let folder = folders[indexPath.row]
        
        vc.folder = folder
        
        vc.title = folder.name
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addFolder() {
        let ac = UIAlertController(title: "New Folder", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        
        let okAction = UIAlertAction(title: "Ok", style: .default) {
            [weak self, weak ac] action in
            guard let folderName = ac?.textFields?[0].text else { return }
            self?.createFolder(folderName)
        }
        
        ac.addAction(okAction)
        
        present(ac, animated: true)
    }
    
    func createFolder(_ folderName: String) {
        folders.insert(Folder(name: folderName, notes: [Note]()), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}

