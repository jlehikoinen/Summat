//
//  AppState.swift
//  Summat
//
//  Created by Janne Lehikoinen on 2.2.2022.
//

import Foundation

class AppState: ObservableObject {
    
    @Published var firstLaunch = true
    
    init() {
        if UserDefaults.exists(key: "FirstLaunch") {
            self.firstLaunch = UserDefaults.standard.bool(forKey:"FirstLaunch")
        }
    }
    
    func handleFirstLaunch() {
        
        let context = CoreDataController.shared.persistentContainer.viewContext
        
        if self.firstLaunch {
            do {
                try Calculator.generateFactoryCalculators(in: context)
                // First launch done, set FirstLaunch key to false
                UserDefaults.standard.set(false, forKey: "FirstLaunch")
            } catch {
                NSLog("Error generating calculators: \(error)")
            }
        } else {
            // App version update logic
            do {
                try Calculator.handleNewFactoryCalculators(in: context)
            } catch {
                NSLog("Error importing new calculators: \(error)")
            }
        }
    }
}
