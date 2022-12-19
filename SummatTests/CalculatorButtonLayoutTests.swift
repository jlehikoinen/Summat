//
//  CalculatorButtonLayoutTests.swift
//  SummatTests
//
//  Created by Janne Lehikoinen on 3.8.2022.
//

import XCTest
@testable import Summat

class CalculatorButtonLayoutTests: XCTestCase {

    let calculatorVM = CalculatorViewModel(calculator: .sample)
    
    func testButtonLayoutChangeFromHorizontalToVerticalOrderWith0Numbers() {
        
        calculatorVM.buttonNumbers = []
        calculatorVM.changeButtonLayoutToVertical()
        XCTAssertTrue(calculatorVM.buttonNumbers.isEmpty)
    }
    
    func testButtonLayoutChangeFromHorizontalToVerticalOrderWith1Number() {
        
        // No changes when only 1 column
        calculatorVM.buttonNumbers = [10]
        calculatorVM.changeButtonLayoutToVertical()
        XCTAssertEqual(calculatorVM.buttonNumbers, [10])
    }
    
    func testButtonLayoutChangeFromHorizontalToVerticalOrderWith4Numbers() {
        
        // No changes when only 1 column
        calculatorVM.buttonNumbers = [10, 20, 30, 40]
        calculatorVM.changeButtonLayoutToVertical()
        XCTAssertEqual(calculatorVM.buttonNumbers, [10, 20, 30, 40])
    }
    
    func testButtonLayoutChangeFromHorizontalToVerticalOrderWith6Numbers() {
        
        calculatorVM.buttonNumbers = [0, 10, 20, 30, 40, 50]
        calculatorVM.changeButtonLayoutToVertical()
        XCTAssertEqual(calculatorVM.buttonNumbers, [0, 30, 10, 40, 20, 50])
    }
    
    func testButtonLayoutChangeFromHorizontalToVerticalOrderWith7Numbers() {
        
        calculatorVM.buttonNumbers = [0, 10, 20, 30, 40, 50, 60]
        calculatorVM.changeButtonLayoutToVertical()
        XCTAssertEqual(calculatorVM.buttonNumbers, [0, 40, 10, 50, 20, 60, 30])
    }
    
    func testButtonLayoutChangeFromHorizontalToVerticalOrderWith10Numbers() {
        
        calculatorVM.buttonNumbers = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90]
        calculatorVM.changeButtonLayoutToVertical()
        XCTAssertEqual(calculatorVM.buttonNumbers, [0, 50, 10, 60, 20, 70, 30, 80, 40, 90])
    }
    
    func testButtonLayoutChangeFromHorizontalToVerticalOrderWith11Numbers() {

        calculatorVM.buttonNumbers = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
        calculatorVM.changeButtonLayoutToVertical()
        XCTAssertEqual(calculatorVM.buttonNumbers, [0, 40, 80, 10, 50, 90, 20, 60, 100, 30, 70])
    }
    
    func testButtonLayoutChangeFromHorizontalToVerticalOrderWith12Numbers() {
        
        calculatorVM.buttonNumbers = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110]
        calculatorVM.changeButtonLayoutToVertical()
        XCTAssertEqual(calculatorVM.buttonNumbers, [0, 40, 80, 10, 50, 90, 20, 60, 100, 30, 70, 110])
    }
    
    func testButtonLayoutChangeFromHorizontalToVerticalOrderWith13Numbers() {
        
        calculatorVM.buttonNumbers = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120]
        calculatorVM.changeButtonLayoutToVertical()
        XCTAssertEqual(calculatorVM.buttonNumbers, [0, 50, 90, 10, 60, 100, 20, 70, 110, 30, 80, 120, 40])
    }
    
    func testButtonLayoutChangeFromHorizontalToVerticalOrderWith14Numbers() {
        
        calculatorVM.buttonNumbers = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130]
        calculatorVM.changeButtonLayoutToVertical()
        XCTAssertEqual(calculatorVM.buttonNumbers, [0, 50, 100, 10, 60, 110, 20, 70, 120, 30, 80, 130, 40, 90])
    }
    
    func testButtonLayoutChangeFromHorizontalToVerticalOrderWith15Numbers() {
        
        calculatorVM.buttonNumbers = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140]
        calculatorVM.changeButtonLayoutToVertical()
        XCTAssertEqual(calculatorVM.buttonNumbers, [0, 50, 100, 10, 60, 110, 20, 70, 120, 30, 80, 130, 40, 90, 140])
    }
  
    func testButtonLayoutChangeFromHorizontalToVerticalOrderWith100Numbers() {

        // No changes when max is exceeded
        calculatorVM.buttonNumbers = Array(0...99)
        calculatorVM.changeButtonLayoutToVertical()
        XCTAssertEqual(calculatorVM.buttonNumbers, Array(0...99))
    }
}
