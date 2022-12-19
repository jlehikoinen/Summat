//
//  UserCalculation.swift
//  Summat
//
//  Created by Janne Lehikoinen on 2.2.2022.
//
//

import CoreData

// MARK: - Core Data

@objc(UserCalculation)
public class UserCalculation: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCalculation> {
        return NSFetchRequest<UserCalculation>(entityName: "UserCalculation")
    }

    @NSManaged public var calculationElements: NSObject?
    @NSManaged public var calculatorName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var saveName: String?
    @NSManaged public var result: Int32
    @NSManaged public var savedTime: Date?
    @NSManaged public var comment: String?
}

extension UserCalculation: Identifiable { }

extension UserCalculation {
    
    public var wrappedCalculatorName: String {
        calculatorName ?? "Unknown calculator"
    }
    
    public var wrappedSaveName: String {
        return saveName ?? String(format: NSLocalizedString("ResultList.PlaceholderSaveName",
                                                            comment: "Result placeholder name"))
    }
    
    public var wrappedCalculationElements: [Int] {
        return calculationElements as? [Int] ?? []
    }
    
    public var wrappedCalculationElementsAsString: String {
        return wrappedCalculationElements.map { String($0) }.joined(separator: " ")
    }
    
    public var wrappedResult: String {
        String(result)
    }
    
    public var wrappedComment: String {
        return comment ?? "Unknown comment"
    }
    
    // MARK: Dates
    
    public var wrappedSavedTimeLongFormat: String {
        return basicDateAndTimeFormatter(date: savedTime ?? Date())
    }
    
    public var wrappedMonthAndYear: String {
        return monthAndYearDateFormatter(date: savedTime ?? Date())
    }
}

// MARK: Helper methods

extension UserCalculation {
    
    static func fetchCalculation(for objectId: NSManagedObjectID, context: NSManagedObjectContext) -> UserCalculation? {
        
        guard let calculation = context.object(with: objectId) as? UserCalculation else {
            return nil
        }
        return calculation
    }
}
    
// MARK: Date helpers

extension UserCalculation {
    
    private func basicDateAndTimeFormatter(date: Date) -> String {
        date.formatted()
    }
    
    // Pre iOS 15 style formatter required for sorting in ResultListViewModel
    private func monthAndYearDateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM y"
        return formatter.string(from: date)
    }
}

// MARK: Sample data

extension UserCalculation {
    
    // Sample UserCalculation for Xcode previews
    static var sample: UserCalculation {
        
        // Get the first result from the in-memory Core Data store
        let context = CoreDataController.resultsPreview.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserCalculation> = UserCalculation.fetchRequest()
        fetchRequest.fetchLimit = 1
        let results = try? context.fetch(fetchRequest)
        return (results?.first!)!
    }
}
