//
//  FolderViewController.swift
//  ConsolidationProject7
//
//  Created by Wbert Castro on 2/8/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import UIKit

class FolderViewController: UITableViewController {
    var folders: [Folder]!
    var folder: Folder!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
        
        let note = folder.notes[indexPath.row]
        
        cell.textLabel?.text = note.content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? NoteViewController else {return}
        
        let note = folder.notes[indexPath.row]
        
        vc.note = note
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addNote() {
        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? NoteViewController else {return}
        
        let note = Note()
        
        folder.notes.insert(note, at: 0)
        vc.note = note
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        
        let jsonData = encodeFolder(folders: folders)
        
        userDefaults.set(jsonData, forKey: "notes")
        
        tableView.reloadData()
    }
}
