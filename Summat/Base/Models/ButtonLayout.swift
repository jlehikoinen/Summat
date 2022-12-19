//
//  ButtonLayOut.swift
//  Summat
//
//  Created by Janne Lehikoinen on 11.3.2022.
//

import Foundation
import SwiftUI

struct ButtonLayout {
    
    // Fixed number of columns
    let oneColumnRange: ClosedRange = 0...AppConfig.Limits.maxNumberOfRows
    let twoColumnRange: ClosedRange = (AppConfig.Limits.maxNumberOfRows + 1)...(AppConfig.Limits.maxNumberOfRows * 2)
    let threeColumnRange: ClosedRange = (AppConfig.Limits.maxNumberOfRows * 2 + 1)...(AppConfig.Limits.maxNumberOfRows * 3)
    
    // MARK: Methods
    
    func composeColumns(with buttonTitles: [CalculatorButtonTitle]) -> [GridItem] {
        
        // TODO: Adapt to screen size etc.
        // Min. 5 rows visible?
        // or use geometry reader and shrink button height
        // If less than 6 buttons => show only one column
        
        switch buttonTitles.count {
        case oneColumnRange:
            return [
                GridItem(.flexible())
            ]
        case twoColumnRange:
            return [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
        default:
            return [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
        }
    }
    
    func changeOrderToVertical(_ buttonNumbers: [Int]) -> [Int] {
        
        //
        var numbersInVerticalOrder = [Int]()
        
        switch buttonNumbers.count {
        case oneColumnRange:
            NSLog("One column => no changes")
            numbersInVerticalOrder = buttonNumbers
        case twoColumnRange:
            numbersInVerticalOrder = changeOrder(for: buttonNumbers, numberOfColumns: 2)
        case threeColumnRange:
            numbersInVerticalOrder = changeOrder(for: buttonNumbers, numberOfColumns: 3)
        default:
            NSLog("Maximum number of buttons: \(AppConfig.Limits.maxNumberOfButtons)")
            numbersInVerticalOrder = buttonNumbers
        }
        
        return numbersInVerticalOrder
    }
    
    // Supports only 2 and 3 columns for now
    // Refactoring required for more thorough solution for 4+ columns and varying number of rows
    private func changeOrder(for numbers: [Int], numberOfColumns: Int) -> [Int] {
        
        //
        var numbersInNewOrder = [Int]()
        let rowRemainder = numbers.count % numberOfColumns
        let numberOfRows = rowRemainder == 0 ? numbers.count / numberOfColumns : numbers.count / numberOfColumns + 1
        
        // Stride works if the last row is "full" or last row has 1 number less than number of columns
        // Note that rowRemainder can be used only with 2 or 3 columns
        if rowRemainder == 0 || rowRemainder == numberOfColumns - 1 {
            numbersInNewOrder = easyStrider(numbers: numbers, numberOfRows: numberOfRows)
        // Case: 3 columns + 1 leftover number in the last row
        } else {
            for rowIndex in 0..<numberOfRows {
                // Catch 1 leftover number in last row in the last iteration
                if rowIndex == numberOfRows - 1 {
                    numbersInNewOrder.append(numbers[rowIndex])
                    break
                }
                
                numbersInNewOrder.append(contentsOf: [
                    numbers[rowIndex],
                    numbers[rowIndex + numberOfRows],
                    numbers[rowIndex + numberOfRows * 2 - 1]
                    ])
            }
        }
        return numbersInNewOrder
    }
    
    private func easyStrider(numbers: [Int], numberOfRows: Int) -> [Int] {
        
        return (0..<numberOfRows).flatMap { rowIndex in
            stride(from: numbers.startIndex + rowIndex,
                   to: numbers.endIndex,
                   by: numberOfRows).map { numbers[$0] }
        }
    }
}
