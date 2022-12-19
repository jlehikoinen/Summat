//
//  CoreDataController.swift
//  Summat
//
//  Created by Janne Lehikoinen on 3.3.2022.
//

import CoreData
import Foundation

// Source: https://www.russellgordon.ca/tutorials/core-data-and-xcode-previews/
// + https://www.raywenderlich.com/27201015-dynamic-core-data-with-swiftui-tutorial-for-ios

class CoreDataController {
    
    //
    static let shared = CoreDataController()
    let persistentContainer: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        
        persistentContainer = NSPersistentContainer(name: "SummatCoreData")
        
        // Don't save information if running in memory
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store failed to load with error: \(error)")
            } else {
                NSLog("Successfully loaded persistent stores.")
            }
        }
    }
}

// MARK: Previews

// ObservableObject required / utilized only for previews
extension CoreDataController: ObservableObject { }

extension CoreDataController {
    
    static var calculatorPreview: CoreDataController = {
        let result = CoreDataController(inMemory: true)
        let context = result.persistentContainer.viewContext
        // Use factory calculators for previews
        for factoryCalculator in FactoryCalculator.allFactoryCalculators {
            let calc = Calculator(context: context)
            calc.id = factoryCalculator.id
            calc.name = factoryCalculator.name
            calc.buttonNumbers = factoryCalculator.buttonNumbers as NSObject
            calc.isFactoryCalculator = factoryCalculator.isFactoryCalculator
            calc.verticalButtonLayout = factoryCalculator.verticalButtonLayout
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

extension CoreDataController {
    
    static var resultsPreview: CoreDataController = {
        let result = CoreDataController(inMemory: true)
        let context = result.persistentContainer.viewContext
        for resultIndex in 0..<10 {
            let result = UserCalculation(context: context)
            result.id = UUID()
            result.calculatorName = "Sample calculator"
            result.savedTime = Date.now
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
