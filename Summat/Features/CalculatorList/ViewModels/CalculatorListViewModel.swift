//
//  CalculatorListViewModel.swift
//  Summat
//
//  Created by Janne Lehikoinen on 11.3.2022.
//

import Foundation
import CoreData

struct CalculatorListViewModel {
    
    func deleteIndividual(_ calculator: Calculator, context: NSManagedObjectContext) {
        
        calculator.isTemporarilyDeleted = true
        
        // Save to Core Data
        do {
            try context.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
        }
    }
    
    func duplicate(_ calculator: Calculator, context: NSManagedObjectContext) {
        
        let newCalc = Calculator(context: context)
        newCalc.id = UUID()
        let suffix = String(format: NSLocalizedString("CalculatorList.DuplicateSuffix", comment: "Duplicate suffix"))
        newCalc.name = "\(calculator.wrappedName) \(suffix)"
        newCalc.savedTime = Date()
        newCalc.buttonNumbers = calculator.buttonNumbers
        newCalc.isFactoryCalculator = false
        
        // Save to Core Data
        do {
            try context.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
        }
    }
}
