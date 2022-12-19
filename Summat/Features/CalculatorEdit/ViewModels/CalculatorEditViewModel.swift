//
//  CalculatorEditViewModel.swift
//  Summat
//
//  Created by Janne Lehikoinen on 14.1.2022.
//

import CoreData
import SwiftUI

class CalculatorEditViewModel: ObservableObject {
 
    //
    let buttonLayout = ButtonLayout()
    
    //
    @Published var gridColumns = [GridItem]()
    
    @Published var calculatorName = "" {
        didSet {
            validateUserComposedCalculator()
        }
    }
    
    @Published var buttonTitles = [CalculatorButtonTitle]() {
        didSet {
            validateUserComposedCalculator()
            composeColumns()
        }
    }
    
    @Published var isComposedCalculatorValid: Bool = false
    
    //
    init() {
        // Create placeholder button titles
        self.buttonTitles = [
            CalculatorButtonTitle(isCharCountWithinBoundaries: true, text: AppConfig.CalculatorEdit.buttonTitlePlaceholderNumberExample),
            CalculatorButtonTitle(isCharCountWithinBoundaries: false, text: "")]
    }
    
    // MARK: CRUD Methods
    
    func addNewCalculatorVsSaveExisting(objectId: NSManagedObjectID?, context: NSManagedObjectContext) {
        
        // Existing calculator
        if let objectId = objectId, let newCalc = Calculator.fetchCalculator(for: objectId, context: context) {
            newCalc.name = calculatorName
            newCalc.savedTime = Date()
            var buttonTitlesAsInts = buttonTitles.compactMap { Int($0.text) }
            // Handle duplicates
            buttonTitlesAsInts = Array(Set(buttonTitlesAsInts))
            newCalc.buttonNumbers = buttonTitlesAsInts as NSObject
        // New calculator
        } else {
            let newCalc = Calculator(context: context)
            newCalc.id = UUID()
            newCalc.name = calculatorName
            newCalc.savedTime = Date()
            var buttonTitlesAsInts = buttonTitles.compactMap { Int($0.text) }
            // Handle duplicates
            buttonTitlesAsInts = Array(Set(buttonTitlesAsInts))
            newCalc.buttonNumbers = buttonTitlesAsInts as NSObject
            newCalc.isFactoryCalculator = false
            newCalc.verticalButtonLayout = false
        }
        
        // Save to Core Data
        do {
            try context.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Methods
    
    func increment() {
        
        if buttonTitles.count == AppConfig.Limits.maxNumberOfButtons {
            return
        }
        
        if buttonTitles.count < AppConfig.Limits.maxNumberOfButtons {
            buttonTitles.append(CalculatorButtonTitle(text: ""))
        }
    }
    
    func decrement() {
        
        if buttonTitles.count == 1 {
            return
        }
        
        if buttonTitles.count > 1 {
            buttonTitles.removeLast()
        }
    }
    
    func validateUserComposedCalculator() {
        
        let allButtonsCharCountIsOk = buttonTitles.allSatisfy { !$0.hasReachedLimit }
        let buttonTitlesAreNotEmpty = buttonTitles.allSatisfy { $0.text.count > 0 }

        if !self.calculatorName.isEmpty && buttonTitlesAreNotEmpty && allButtonsCharCountIsOk {
            self.isComposedCalculatorValid = true
        } else {
            self.isComposedCalculatorValid = false
        }
    }
    
    //
    func composeColumns() {
        
        gridColumns = buttonLayout.composeColumns(with: buttonTitles)
    }
}
