//
//  ViewController.swift
//  Project1
//
//  Created by Wbert Castro on 12/9/19.
//  Copyright © 2019 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()
    var viewCount = [String: Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path).sorted()
            
            for item in items {
                if item.hasPrefix("nssl") {
                    // this is a picture!!
                    self?.pictures.append(item)
                }
            }
            
            self?.getViews()
            
            DispatchQueue.main.async {
               [weak self] in
                   self?.collectionView.reloadData()
               }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else {
            fatalError("Couldn't dequeue a picture cell!")
        }
        
        let picture = pictures[indexPath.item]
        
        cell.name.text = picture
        cell.image.image = UIImage(named: picture)
        let views = viewCount[picture] ?? 0
        cell.viewCount.text = "Views \(views)"
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.item]
            vc.currentImage = indexPath.row
            vc.imageCount = pictures.count
            updateViews(imageIndex: indexPath.item)
            collectionView.reloadItems(at: [indexPath])
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getViews() {
        let defaults = UserDefaults.standard
        viewCount = defaults.object(forKey: "views") as? [String: Int] ?? [String: Int]()
    }
    
    func updateViews(imageIndex: Int) {
        let defaults = UserDefaults.standard
        
        let views = viewCount[pictures[imageIndex]] ?? 0;
        
        viewCount[pictures[imageIndex]] = views + 1
        
        defaults.set(viewCount, forKey: "views")
    }
}
