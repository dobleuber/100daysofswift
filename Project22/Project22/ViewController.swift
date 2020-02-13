//
//  ViewController.swift
//  Project22
//
//  Created by Wbert Castro on 2/11/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var distanceReadin2: UILabel!
    @IBOutlet var signalStrenghtImage: UIImageView!
    var locationManager: CLLocationManager?
    var firstAlert = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        let beacon2Region = CLBeaconRegion(proximityUUID: uuid, major: 456, minor: 123, identifier: "MySecondBeacon")
        
        locationManager?.stopMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
        locationManager?.stopMonitoring(for: beacon2Region)
        locationManager?.startRangingBeacons(in: beacon2Region)
    }
    
    func update(distance: CLProximity, beacon: Int) {
        let selectedLabel = getProperLabel(selectedIndex: beacon)
        UIView.animate(withDuration: 1) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = .gray
                selectedLabel?.text = "UNKNOWN"
                self.signalStrenghtImage.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            case .far:
                self.showFirstAlert()
                self.view.backgroundColor = .blue
                selectedLabel?.text = "FAR"
                self.signalStrenghtImage.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case .near:
                self.view.backgroundColor = .orange
                selectedLabel?.text = "NEAR"
                self.signalStrenghtImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .immediate:
                self.view.backgroundColor = .red
                selectedLabel?.text = "RIGHT HERE"
                self.signalStrenghtImage.transform = CGAffineTransform(scaleX: 1, y: 1)
            @unknown default:
                self.view.backgroundColor = .gray
                selectedLabel?.text = "UNKNOWN"
                self.signalStrenghtImage.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let hasBeacons = beacons.count > 0
        if !hasBeacons {
            update(distance: .unknown, beacon: 0)
        }
        for beacon in beacons {
            update(distance: beacon.proximity, beacon: beacon.major == 123 ? 1 : 2)
        }
    }
    
    func showFirstAlert() {
        if (!firstAlert) {
            let ac = UIAlertController(title: "You are close to the beacon!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            firstAlert = true
            present(ac, animated: true)
        }
    }
    
    func getProperLabel(selectedIndex: Int) -> UILabel? {
        if selectedIndex == 1 {
            return distanceReading
        } else if selectedIndex == 2 {
            return distanceReadin2
        }
        
        return nil
        
    }
}

