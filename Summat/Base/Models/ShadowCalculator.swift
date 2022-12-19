//
//  ShadowCalculator.swift
//  Summat
//
//  Created by Janne Lehikoinen on 14.1.2022.
//

import Foundation

struct ShadowCalculator: Codable, Identifiable {
    
    var id = UUID()
    var name: String
    var totalSum: Int = 0
    var buttonNumbers: [Int]
    var calculationElements: [Int] = []
    var isFactoryCalculator: Bool
    var verticalButtonLayout: Bool
    var introducedInVersion: String
}

extension ShadowCalculator {
    
    #if DEBUG
    static let sampleCalculator1 = ShadowCalculator(id: UUID(uuidString: "ABBAACDC-0000-0000-0000-000000000001")!,
                                                    name: "Fortuna",
                                                    buttonNumbers: [10, 20, 25, 50, 75, 90, 100, 125, 150],
                                                    isFactoryCalculator: true,
                                                    verticalButtonLayout: false,
                                                    introducedInVersion: "1.0.0")
    #endif
}
