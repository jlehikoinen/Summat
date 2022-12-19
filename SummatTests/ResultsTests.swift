//
//  ResultsTests.swift
//  SummatTests
//
//  Created by Janne Lehikoinen on 21.6.2022.
//

import XCTest
@testable import Summat
import CoreData

class ResultsTests: XCTestCase {

    //
    let resultListVM = ResultListViewModel()
    
    // MARK: Basic tests

    func testResultsWithBasicTests() {
        
        // Get the first result from the in-memory Core Data store
        let testContext = CoreDataController.resultsTestDataWithMultipleMonths.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserCalculation> = UserCalculation.fetchRequest()
        fetchRequest.fetchLimit = 1
        let results = try? testContext.fetch(fetchRequest)
        let testResult = results!.first!
        
        // Run basic tests
        XCTAssertNotNil(testResult, "UserCalculation/Result should not be nil")
        XCTAssertNotNil(testResult.id, "id should not be nil")
        XCTAssertEqual(testResult.calculatorName, "Test calculator")
        XCTAssertNotNil(testResult.savedTime, "Saved time should not be nil")
        XCTAssertTrue(testResult.calculationElements == [100, 300, 50, 500, 50] as NSObject)
        XCTAssertTrue(testResult.result == Int32(1000))
        XCTAssertTrue(testResult.comment == "Sample comment")
    }

    // MARK: Section date tests (note Finnish region localization with month names)
    
    func testResultsWithDatesWithManyMonthsReturnsManySectionsSortedInAscendingOrder() {

        // Get the first 10 results from the in-memory Core Data store
        let testContext = CoreDataController.resultsTestDataWithMultipleMonths.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserCalculation> = UserCalculation.fetchRequest()
        fetchRequest.fetchLimit = 10
        let userCalculations = try? testContext.fetch(fetchRequest)

        let listOfMonthsAndYears = userCalculations!.map { $0.wrappedMonthAndYear }
        let monthAndYearSections = resultListVM.sortMonths(monthsAndYears: listOfMonthsAndYears)

        //
        XCTAssertTrue(monthAndYearSections.count == 4)
        XCTAssertEqual(monthAndYearSections.first, "heinäkuuta 2022")
        XCTAssertEqual(monthAndYearSections, ["heinäkuuta 2022", "kesäkuuta 2022", "toukokuuta 2022", "huhtikuuta 2022"])
    }
    
    func testResultsWithDatesWithOneMonthReturnsOneSection() {
        
        // Get the results from the in-memory Core Data store
        let testContext = CoreDataController.resultsTestDataWithOneMonth.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserCalculation> = UserCalculation.fetchRequest()
        let userCalculations = try? testContext.fetch(fetchRequest)

        let listOfMonthsAndYears = userCalculations!.map { $0.wrappedMonthAndYear }
        let monthAndYearSections = resultListVM.sortMonths(monthsAndYears: listOfMonthsAndYears)

        //
        XCTAssertTrue(monthAndYearSections.count == 1)
        XCTAssertEqual(monthAndYearSections, ["huhtikuuta 2022"])
    }
    
    func testZeroResultsReturnsZeroSections() {

        let listOfMonthsAndYears: [String] = []
        let monthAndYearSections = resultListVM.sortMonths(monthsAndYears: listOfMonthsAndYears)
        
        //
        XCTAssertTrue(monthAndYearSections.isEmpty)
    }
}
