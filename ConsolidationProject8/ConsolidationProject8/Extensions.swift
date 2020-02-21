//
//  Extensions.swift
//  ConsolidationProject8
//
//  Created by Wbert Castro on 2/20/20.
//  Copyright © 2020 Wbert Castro. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func bounceOut(duration: Int) {
        UIView.animate(withDuration: Double(duration)) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
    
    func bounceIn() {
        UIView.animate(withDuration: 1) {
            self.transform = .identity
        }
    }
}

extension Int {
    func times(myFunc: () -> Void) {
        for _ in 0...abs(self) {
            myFunc()
        }
    }
}

extension Array where Element: Comparable {
    func removeItem(item: Element) {
        for i in self {
            if i == item {
                self.removeItem(item: i)
                return
            }
        }
    }
}
