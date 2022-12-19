//
//  ResultsTestData.swift
//  SummatTests
//
//  Created by Janne Lehikoinen on 22.6.2022.
//

@testable import Summat
import CoreData

extension CoreDataController {
    
    static var resultsTestDataWithMultipleMonths: CoreDataController = {
        let result = CoreDataController(inMemory: true)
        let context = result.persistentContainer.viewContext
        for resultIndex in 0..<10 {
            let result = UserCalculation(context: context)
            result.id = UUID()
            result.calculatorName = "Test calculator"
            // Create test dates, dates should be within these months: ["heinäkuuta 2022", "kesäkuuta 2022", "toukokuuta 2022", "huhtikuuta 2022"]
            result.savedTime = Date(timeIntervalSince1970: TimeInterval(1_650_000_000 + (resultIndex * 1_000_000)))
            result.calculationElements = [100, 300, 50, 500, 50] as NSObject
            result.result = Int32(1000)
            result.comment = "Sample comment"
        }
        do {
            try context.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
        }
        return result
    }()
    
    static var resultsTestDataWithOneMonth: CoreDataController = {
        let result = CoreDataController(inMemory: true)
        let context = result.persistentContainer.viewContext
        for resultIndex in 0..<2 {
            let result = UserCalculation(context: context)
            result.id = UUID()
            result.calculatorName = "Test calculator"
            // Create test dates, dates should only be within "huhtikuuta 2022" month
            result.savedTime = Date(timeIntervalSince1970: TimeInterval(1_650_000_000 + resultIndex))
            result.calculationElements = [100, 300, 50, 500, 50] as NSObject
            result.result = Int32(1000)
            result.comment = "Sample comment"
        }
        do {
            try context.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
        }
        return result
    }()
}

// MARK: Test data

extension UserCalculation {
    
    public var dateWithRandomMonth: Date {
        var monthComponent = DateComponents()
        monthComponent.month = Int.random(in: 1..<12)
        let calendar = Calendar.current
        let randomDate = calendar.date(byAdding: monthComponent, to: savedTime ?? Date())
        NSLog("Random date: \(String(describing: randomDate))")
        return randomDate ?? Date()
    }
}
