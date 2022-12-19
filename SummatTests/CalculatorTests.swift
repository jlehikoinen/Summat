//
//  CalculatorTests.swift
//  SummatTests
//
//  Created by Janne Lehikoinen on 22.6.2022.
//

import XCTest
@testable import Summat
import CoreData

class CalculatorTests: XCTestCase {

    let calculatorVM = CalculatorViewModel(calculator: .sample)
    
    // MARK: Basic calculator functionality tests
    
    func testAddNumberToTotalSum() {
        
        calculatorVM.totalSum = 1
        calculatorVM.addToSum(2)
        
        XCTAssertEqual(calculatorVM.totalSum, 3)
    }

    func testRemoveLastNumberFromTotalSum() {
        
        calculatorVM.calculationElements = [1, 2]
        calculatorVM.totalSum = 3
        calculatorVM.removeLastDigit()
        
        XCTAssertEqual(calculatorVM.totalSum, 1)
    }
    
    func testRemoveLastNumberWhenCalculationElementsCountIsZero() {
        
        calculatorVM.calculationElements = []
        calculatorVM.removeLastDigit()
        
        XCTAssertEqual(calculatorVM.totalSum, 0)
    }
    
    func testResetTotalSum() {
        
        calculatorVM.calculationElements = [1, 2]
        calculatorVM.totalSum = 3
        calculatorVM.resetSum()
        
        XCTAssertEqual(calculatorVM.totalSum, 0)
    }
    
    // MARK: Save result test (todo)
    
    func testSaveResult() {
        
    }
}
