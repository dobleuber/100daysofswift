//
//  ViewController.swift
//  ConsolidationProject4
//
//  Created by Wbert Castro on 1/12/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var pictures = [Picture]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePicture))
        
        loadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        let picture = pictures[indexPath.row]
        
        cell.textLabel?.text = picture.caption
        
        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            let picture = pictures[indexPath.row]
            
            let path = getDocumentsDirectory().appendingPathComponent(picture.fileName)
            vc.title = picture.caption
            vc.pictureFilePath = path.path
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let fileName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(fileName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        tableView.reloadData()
        dismiss(animated: true) {
            let ac = UIAlertController(title: "Add Caption", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            ac.addAction(UIAlertAction(title: "ok", style: .default) {
                [weak self, weak ac] _ in
                guard let newCaption = ac?.textFields?[0].text else {return}
                let picture = Picture(caption: newCaption, fileName: fileName)
                self?.pictures.append(picture)
                self?.tableView.reloadData()
                self?.savePictures()
            })
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(ac, animated: true)
        }
    }

    @objc func takePicture () {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func savePictures () {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save pictures")
        }
    }

    func loadData () {
        let defaults = UserDefaults.standard
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
               let jsonDecoder = JSONDecoder()
           
           do {
               pictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
           } catch {
               print("Failed to load pictures")
           }
       }
    }
}

