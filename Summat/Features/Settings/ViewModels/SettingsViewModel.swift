//
//  SettingsViewModel.swift
//  Summat
//
//  Created by Janne Lehikoinen on 11.3.2022.
//

import CoreData

struct SettingsViewModel {
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "n/a"
    }
}
