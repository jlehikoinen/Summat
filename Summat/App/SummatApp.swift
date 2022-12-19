//
//  SummatApp.swift
//  Summat
//
//  Created by Janne Lehikoinen on 14.1.2022.
//

import SwiftUI

@main
struct SummatApp: App {
    
    private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            CalculatorListScreen()
                .environment(\.managedObjectContext, CoreDataController.shared.persistentContainer.viewContext)
                .environmentObject(appState)
                .preferredColorScheme(.dark)
                .onAppear {
                    appState.handleFirstLaunch()
                    #if targetEnvironment(macCatalyst)
                    setupMacWindowSize()
                    #endif
                }
        }
    }
        
    private func setupMacWindowSize() {
        UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
            // Min. width should be around 600 so that the sheet width won't overlap window width
            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 580, height: 720)
            windowScene.sizeRestrictions?.maximumSize = CGSize(width: 580, height: 720)
        }
    }
}
