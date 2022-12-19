//
//  FactoryCalculators.swift
//  Summat
//
//  Created by Janne Lehikoinen on 14.1.2022.
//

import Foundation

enum FactoryCalculator {
    
    // Names
    static let fortunaName = String(format: NSLocalizedString("FactoryCalculators.Fortuna",
                                                              comment: "Factory calculator: Fortuna"))
    static let throwThePigGameName = String(format: NSLocalizedString("FactoryCalculators.ThrowThePigGame",
                                                                      comment: "Factory calculator: Throw The Pig Game"))
    static let finnishDartsName = String(format: NSLocalizedString("FactoryCalculators.FinnishDarts",
                                                                   comment: "Factory calculator: Finnish Darts"))
    static let snowboardingTrickName = String(format: NSLocalizedString("FactoryCalculators.SnowboardingTrick",
                                                                        comment: "Factory calculator: Snowboarding Trick"))
    static let finnishRingTossGameName = String(format: NSLocalizedString("FactoryCalculators.FinnishRingTossGame",
                                                                          comment: "Factory calculator: Finnish Ring Toss Game"))
    static let dosaName = String(format: NSLocalizedString("FactoryCalculators.DOSA", comment: "Factory calculator: DOSA"))
    
    //
    static let fortuna = ShadowCalculator(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                                          name: fortunaName,
                                          buttonNumbers: [0, 10, 20, 25, 50, 75, 90, 100, 125, 150],
                                          isFactoryCalculator: true,
                                          verticalButtonLayout: true,
                                          introducedInVersion: "1.0.0")
    
    static let finnishThrowThePigGame = ShadowCalculator(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                                                         name: throwThePigGameName,
                                                         buttonNumbers: [0, 1, 5, 10, 15, 20, 30, 60],
                                                         isFactoryCalculator: true,
                                                         verticalButtonLayout: false,
                                                         introducedInVersion: "1.0.0")
    
    static let finnishDarts = ShadowCalculator(id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
                                               name: finnishDartsName,
                                               buttonNumbers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                                               isFactoryCalculator: true,
                                               verticalButtonLayout: true,
                                               introducedInVersion: "1.0.0")
    
    static let snowboardingTrick = ShadowCalculator(id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
                                                    name: snowboardingTrickName,
                                                    buttonNumbers: [90, 180, 360],
                                                    isFactoryCalculator: true,
                                                    verticalButtonLayout: true,
                                                    introducedInVersion: "1.0.0")
    
    static let finnishRingTossGame = ShadowCalculator(id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
                                                      name: finnishRingTossGameName,
                                                      buttonNumbers: [0, 20, 30, 50],
                                                      isFactoryCalculator: true,
                                                      verticalButtonLayout: true,
                                                      introducedInVersion: "1.0.0")
    
    static let dosa = ShadowCalculator(id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!,
                                       name: dosaName,
                                       buttonNumbers: [0, 1, 2, 3, 4, 5, 6, 8, 10],
                                       isFactoryCalculator: true,
                                       verticalButtonLayout: true,
                                       introducedInVersion: "1.1.0")
    
    //
    static let allFactoryCalculators = [fortuna, finnishThrowThePigGame, finnishDarts, snowboardingTrick, finnishRingTossGame, dosa]
}
