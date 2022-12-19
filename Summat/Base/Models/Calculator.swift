//
//  Calculator.swift
//  Summat
//
//  Created by Janne Lehikoinen on 2.2.2022.
//
//

import CoreData

// MARK: - Core Data

@objc(Calculator)
public class Calculator: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Calculator> {
        return NSFetchRequest<Calculator>(entityName: "Calculator")
    }

    @NSManaged public var buttonNumbers: NSObject?
    @NSManaged public var id: UUID?
    @NSManaged public var introducedInVersion: String?
    @NSManaged public var userHasntSeenTheCalculator: Bool
    @NSManaged public var isFactoryCalculator: Bool
    @NSManaged public var isTemporarilyDeleted: Bool
    @NSManaged public var verticalButtonLayout: Bool
    @NSManaged public var name: String?
    @NSManaged public var savedTime: Date?
}

extension Calculator: Identifiable { }

extension Calculator {
    
    public var wrappedName: String {
        name ?? ""
    }

    public var wrappedButtonNumbers: [Int] {
        let set = buttonNumbers as? [Int] ?? []
        return set.sorted { $0 < $1 }
    }
}

// MARK: Helper methods

extension Calculator {
    
    static func fetchCalculator(for objectId: NSManagedObjectID, context: NSManagedObjectContext) -> Calculator? {
        
        guard let calculator = context.object(with: objectId) as? Calculator else {
            return nil
        }
        return calculator
    }
}

// MARK: Factory calculators

extension Calculator {
    
    static func generateFactoryCalculators(in context: NSManagedObjectContext) throws {
        
        NSLog("Importing factory calculators to the Core Data model...")
        
        // Insert all factory calculators to Core Data
        for factoryCalculator in FactoryCalculator.allFactoryCalculators {
            let calc = Calculator(context: context)
            calc.id = factoryCalculator.id
            calc.name = factoryCalculator.name
            calc.buttonNumbers = factoryCalculator.buttonNumbers as NSObject
            calc.isFactoryCalculator = factoryCalculator.isFactoryCalculator
            calc.verticalButtonLayout = factoryCalculator.verticalButtonLayout
        }
        
        // Save to Core Data
        do {
            try context.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
        }
    }
    
    // If you want to introduce new factory calculator, introducedInVersion needs to match with the app version number used in release
    static func handleNewFactoryCalculators(in context: NSManagedObjectContext) throws {
        
        //
        let fetchRequest: NSFetchRequest<Calculator> = Calculator.fetchRequest()
        let existingCalculators = try? context.fetch(fetchRequest)
        
        for factoryCalculator in FactoryCalculator.allFactoryCalculators {
            
            // If introducedInVersion < appVersionNumber => continue
            if factoryCalculator.introducedInVersion.compare(Bundle.main.appVersionNumber, options: .numeric) == .orderedAscending {
                continue
            }
            
            // If introducedInVersion == appVersionNumber
            if factoryCalculator.introducedInVersion.compare(Bundle.main.appVersionNumber, options: .numeric) == .orderedSame {
                
                // Get list of calculators that already exists (including deleted ones)
                let existingCalculatorIds = existingCalculators!.map { $0.id }

                // If existing calculators don't contain calculator => introduce new calculator
                if !existingCalculatorIds.contains(factoryCalculator.id) {
                    
                    NSLog("Importing new factory calculator \(factoryCalculator.id) to the Core Data model...")
                    
                    let calc = Calculator(context: context)
                    calc.id = factoryCalculator.id
                    calc.name = factoryCalculator.name
                    calc.buttonNumbers = factoryCalculator.buttonNumbers as NSObject
                    calc.isFactoryCalculator = factoryCalculator.isFactoryCalculator
                    calc.verticalButtonLayout = factoryCalculator.verticalButtonLayout
                    
                    //
                    calc.userHasntSeenTheCalculator = true
                }
            }
        }
        
        // Save to Core Data
        do {
            try context.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
        }
    }
    
    static func restoreFactoryCalculators(context: NSManagedObjectContext) {
        
        NSLog("Deleting factory calculators...")
        
        let fetchRequest: NSFetchRequest<Calculator> = Calculator.fetchRequest()
        let calculators = try? context.fetch(fetchRequest)

        let factoryCalculatorIds = FactoryCalculator.allFactoryCalculators.map { $0.id }
        
        for calculator in calculators! {
            if factoryCalculatorIds.contains(calculator.id!) {
                NSLog("Deleting \(String(describing: calculator.id))")
                context.delete(calculator)
                
                // Save to Core Data
                do {
                    try context.save()
                } catch {
                    let error = error as NSError
                    fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
                }
            }
        }
        
        // Then add all factory calculators back
        do {
            try Calculator.generateFactoryCalculators(in: context)
        } catch {
            NSLog("Error generating calculators: \(error)")
        }
    }
}

// MARK: Sample data

extension Calculator {
    
    // Sample calculator for Xcode previews
    static var sample: Calculator {
        
        // Get the first calculator from the in-memory Core Data store
        let context = CoreDataController.calculatorPreview.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Calculator> = Calculator.fetchRequest()
        fetchRequest.fetchLimit = 1
        let results = try? context.fetch(fetchRequest)
        return (results?.first!)!
    }
}
