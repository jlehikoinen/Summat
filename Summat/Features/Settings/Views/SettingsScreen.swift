//
//  SettingsScreen.swift
//  Summat
//
//  Created by Janne Lehikoinen on 14.1.2022.
//

import SwiftUI

struct SettingsScreen: View {
    
    //
    let settingsVM = SettingsViewModel()
    
    // Core Data
    @FetchRequest(sortDescriptors: []) var calculators: FetchedResults<Calculator>
    @Environment(\.managedObjectContext) var viewContext
    
    // User settings
    @AppStorage(UserSettings.enableButtonSoundsKey) var enableButtonSounds: Bool = true
    @AppStorage(UserSettings.enableHapticFeedbackKey) var enableHapticFeedback: Bool = true
    @AppStorage(UserSettings.enableCalculatorEntranceAnimationKey) var enableCalculatorEntranceAnimation: Bool = true
    
    //
    @Environment(\.dismiss) var dismiss
    
    //
    @State var presentingRestoreSheet: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Settings.Header.CalculatorSettings")) {
                        Toggle("Settings.ButtonSounds", isOn: $enableButtonSounds)
                        Toggle("Settings.HapticFeedback", isOn: $enableHapticFeedback)
                        Toggle("Settings.CalculatorEntranceAnimation", isOn: $enableCalculatorEntranceAnimation)
                    }
                    Section(header: Text("Settings.Header.FactorySettings")) {
                        Button(action: displayRestoreSheet) {
                            Text("Settings.FactoryRestoreButton")
                        }
                    }
                    Section(header: Text("Settings.Header.AppInfo")) {
                        HStack {
                            Text("Settings.Version")
                            Spacer()
                            Text(settingsVM.appVersion)
                                .foregroundColor(.secondary)
                                .latoFont(.bodySmall)
                        }
                    }
                }
                .confirmationDialog("Settings.FactoryRestoreConfirmationDescription", isPresented: $presentingRestoreSheet, titleVisibility: .visible) {
                    Button(role: .none, action: restoreFactoryCalculators) {
                        Label("Settings.FactoryRestoreConfirmationButton", systemImage: "restart.circle")
                    }
                }
            }
            .navigationBarTitle("Settings.Title")
            .toolbar {
                toolbarContent()
            }
        }
    }
    
    // MARK: View components
    
    var closeSheetButton: some View {
        Button {
            dismiss()
        } label: {
            DismissSheetButton()
        }
    }
    
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            closeSheetButton
        }
    }
    
    // MARK: View helper methods
    
    private func displayRestoreSheet() {
        
        self.presentingRestoreSheet = true
    }
    
    // MARK: Restore factory calculators
    
    private func restoreFactoryCalculators() {

        Calculator.restoreFactoryCalculators(context: viewContext)
        dismiss()
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
            .preferredColorScheme(.dark)
            .environment(\.locale, .init(identifier: "en"))
        
        SettingsScreen()
            .preferredColorScheme(.dark)
            .environment(\.locale, .init(identifier: "fi"))
    }
}
