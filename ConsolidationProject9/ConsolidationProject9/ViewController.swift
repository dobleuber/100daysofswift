//
//  ViewController.swift
//  ConsolidationProject9
//
//  Created by Wbert Castro on 3/1/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    
    var topString: String? = "Test 1"
    var bottomString: String? = "Test 2"
    var originalImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(callImportImage))
        let sharedButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        navigationItem.leftBarButtonItems = [cameraButton, sharedButton]
        let topText = UIBarButtonItem(title: "Top", style: .plain, target: self, action: #selector(showTopAlert))
        let bottomText = UIBarButtonItem(title: "Bottom", style: .plain, target: self, action: #selector(showBottomAlert))
        navigationItem.rightBarButtonItems = [bottomText, topText]
    }
    
    @objc func callImportImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func showTopAlert() {
        let ac = UIAlertController(title: "Top Text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Ok", style: .default) {
            [weak self, weak ac] action in
            guard let topText = ac?.textFields?[0].text else {return}
            self?.topString = topText
            self?.updateImage()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    @objc func showBottomAlert() {
        let ac = UIAlertController(title: "Bottom Text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Ok", style: .default) {
            [weak self, weak ac] action in
            guard let bottomText = ac?.textFields?[0].text else {return}
            self?.bottomString = bottomText
            self?.updateImage()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image else {
            print("No image found")
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [imageData], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        originalImage = image
        
        dismiss(animated: true)
        
        updateImage()
    }
    
    func updateImage() {
        guard let currentImage = originalImage else {return}
        
        let renderer = UIGraphicsImageRenderer(size: currentImage.size)
        
        let image = renderer.image {
            ctx in
            
            currentImage.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 128),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.white
            ]
            
            if let topString = self.topString {
                let attributedString = NSAttributedString(string: topString, attributes: attrs)
                attributedString.draw(
                    with: CGRect(x: 32, y: 64, width: currentImage.size.width - 32, height: 128 * 2),
                    options: .usesLineFragmentOrigin, context: nil
                )
            }
            
            if let bottomString = self.bottomString {
                let attributedString = NSAttributedString(string: bottomString, attributes: attrs)
                attributedString.draw(
                    with: CGRect(x: 32, y: currentImage.size.height - 216, width: currentImage.size.width - 32, height: 128 * 2),
                    options: .usesLineFragmentOrigin, context: nil
                )
            }
        }
        
        imageView.image = image
    }
}

