//
//  CalculatorButtonTitle.swift
//  Summat
//
//  Created by Janne Lehikoinen on 8.2.2022.
//

import Foundation

struct CalculatorButtonTitle {
    
    var isCharCountWithinBoundaries = false
    var hasReachedLimit = false
    
    var text: String {
        // This is called twice every time text is accessed
        didSet {
            switch text.count {
            case 0:
                self.isCharCountWithinBoundaries = false
            case 1...AppConfig.Limits.maxButtonChars:
                self.hasReachedLimit = false
                self.isCharCountWithinBoundaries = true
            default:
                self.hasReachedLimit = true
                self.isCharCountWithinBoundaries = false
            }
        }
    }
}
