//
//  DetailViewController.swift
//  Project1
//
//  Created by Wbert Castro on 12/10/19.
//  Copyright © 2019 Wbert Castro. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var currentImage: Int?
    var imageCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Picture \(currentImage! + 1) of \(imageCount!)"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                barButtonSystemItem: .action,
                target: self,
                action: #selector(shareTapped)
        )
        
        if let imageToLoad = selectedImage {
            guard let image = UIImage(named: imageToLoad) else {
                print("No image found")
                return
            }
            
            imageView.image = image
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image else {
            print("No image found")
            return
        }
        
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let newImage = renderer.image {
            ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "From Storm Viewer"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            image.draw(at: CGPoint(x: 0, y: 0))
            
            attributedString.draw(
                with: CGRect(x: 20, y: 20, width: image.size.width - 20, height: image.size.height - 20),
                options: .usesLineFragmentOrigin, context: nil
            )
        }
        
        guard let imageData = newImage.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [imageData, selectedImage!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(vc, animated: true)
    }
}
