//
//  ActionViewController.swift
//  Extension
//
//  Created by Wbert Castro on 1/30/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(chooseDefinedAction))
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) {
                    [weak self] (dict, error) in
                    guard let itemDictionary = dict
                        as? NSDictionary else {
                        return
                    }
                    
                    guard let javascriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey]
                        as? NSDictionary else {
                        return
                    }
                    
                    self?.pageTitle = javascriptValues["title"] as? String ?? ""
                    self?.pageURL = javascriptValues["URL"] as? String ?? ""
                    
                    let userDefaults = UserDefaults.standard
                    var prevScript: String?
                    
                    if let url = self?.pageURL {
                        prevScript = userDefaults.string(forKey: url)
                    }
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        if prevScript != nil {
                            self?.script.text = prevScript
                        }
                    }
                }
            }
        }
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text!]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(script.text!, forKey: pageURL)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @objc func chooseDefinedAction() {
        let ac = UIAlertController(title: "Predefined Actions", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Say hi", style: .default) {
            [weak self] _ in
            self?.script.text =
                """
                alert('Hi')
                """
        })
        
        ac.addAction(UIAlertAction(title: "Say bye", style: .default) {
            [weak self] _ in
            self?.script.text =
                """
                alert('Bye')
                """
        })
        
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(ac, animated: true)
    }

}
