//
//  ResultDetailViewModel.swift
//  Summat
//
//  Created by Janne Lehikoinen on 12.4.2022.
//

import CoreData
import SwiftUI

class ResultDetailViewModel: ObservableObject {
    
    @Published var userCalculation: UserCalculation
    @Published var resultSaveName = String(format: NSLocalizedString("ResultList.PlaceholderSaveName", comment: "Result placeholder name"))
    
    //
    init(userCalculation: UserCalculation) {
        self.userCalculation = userCalculation
    }
    
    func handleExistingProperties() {
        self.resultSaveName = self.userCalculation.wrappedSaveName
    }
    
    func saveCalculation(for userCalculation: UserCalculation, context: NSManagedObjectContext) {
        
        if let newUserCalculation = UserCalculation.fetchCalculation(for: userCalculation.objectID, context: context) {
            newUserCalculation.id = UUID()
            newUserCalculation.calculatorName = userCalculation.calculatorName
            newUserCalculation.saveName = self.resultSaveName
            newUserCalculation.savedTime = userCalculation.savedTime
            newUserCalculation.calculationElements = userCalculation.calculationElements
            newUserCalculation.result = userCalculation.result
            newUserCalculation.comment = userCalculation.comment
            
            // Save to Core Data
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }
    }
}
