//
//  AppConfig.swift
//  Summat
//
//  Created by Janne Lehikoinen on 14.1.2022.
//

import SwiftUI

enum AppConfig {
    
    enum Limits {
        
        static let maxButtonChars = 5
        static let maxNumberOfRows = 5
        static let maxNumberOfButtons = 15
    }
    
    enum List {
        
        static let minListRowHeight: CGFloat = 48
    }
    
    enum CalculatorEdit {
        
        static let buttonTitlePlaceholderNumberExample = "100"
        static let buttonTitlePlaceholderEmpty = "000"
    }
    
    enum ButtonSize {
    
        static let minWidthiPhone: CGFloat = UIDevice.isiPod ? 80 : 100
        static let minHeightiPhone: CGFloat = UIDevice.isiPod ? 44 : 56
    }
    
    // MARK: Helper funcs
    
    static func isiOSAppOnMac() -> Bool {
        
        if #available(iOS 14.0, *) {
            return ProcessInfo.processInfo.isiOSAppOnMac
        }
        return false
    }
}
