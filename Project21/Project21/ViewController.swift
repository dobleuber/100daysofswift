//
//  ViewController.swift
//  Project21
//
//  Created by Wbert Castro on 2/4/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                print ("Yay!")
            } else {
                print("Upps!")
            }
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = createAlertNotification()
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 20
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let remindLater = UNNotificationAction(identifier: "later", title: "Remind me later", options: .destructive)
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindLater], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                let ac = UIAlertController(title: "Default", message: "Default message", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                present(ac, animated: true)
            case "show":
                let ac = UIAlertController(title: "Showing more info", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                present(ac, animated: true)
            case "later":
                let center = UNUserNotificationCenter.current()
                let content = createAlertNotification()
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    func createAlertNotification() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "bizzbizz"]
        content.sound = .default
        
        return content
    }
}

