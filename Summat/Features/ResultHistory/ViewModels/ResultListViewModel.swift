//
//  ResultListViewModel.swift
//  Summat
//
//  Created by Janne Lehikoinen on 10.3.2022.
//

import CoreData

struct ResultListViewModel {
    
    func deleteIndividual(_ calculation: UserCalculation, context: NSManagedObjectContext) {
            
        context.delete(calculation)
        
        // Save to Core Data
        do {
            try context.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
        }
    }
    
    func sortMonths(monthsAndYears: [String]) -> [String] {
        
        let sortFormatter = DateFormatter()
        sortFormatter.dateFormat = "MMMM y"
        let reducedArray = Array(Set(monthsAndYears))
        return reducedArray.sorted(by: { sortFormatter.date(from: $0)! > sortFormatter.date(from: $1)! } )
    }
}
