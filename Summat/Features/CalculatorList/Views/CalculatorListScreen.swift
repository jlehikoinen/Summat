//
//  CalculatorListScreen.swift
//  Summat
//
//  Created by Janne Lehikoinen on 14.1.2022.
//

import SwiftUI

struct CalculatorListScreen: View {
    
    //
    let calculatorListVM = CalculatorListViewModel()
    
    // Core Data
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.savedTime, order: .reverse)], animation: .default) var calculators: FetchedResults<Calculator>
    @Environment(\.managedObjectContext) var viewContext
    
    // Sheets
    @State private var presentingNewCalculatorSheet: Bool = false
    @State private var presentingResultsSheet: Bool = false
    @State private var presentingSettingsSheet: Bool = false
    
    //
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 1) {
                    
                    headerBackground
                    
                    List {
                        
                        Section(header: Text("CalculatorList.UserSections")
                            .foregroundStyle(LinearGradient(.green, .blue))) {
                                
                                if calculators.filter { $0.isFactoryCalculator == false && $0.isTemporarilyDeleted == false }.isEmpty {
                                    noUserCalculatorsPlaceholderButton
                                } else {
                                    userCalculatorList
                                }
                            }
                        
                        Section(header: Text("CalculatorList.FactorySections")
                            .foregroundStyle(LinearGradient(.red, .yellow))) {
                                if calculators.filter { $0.isFactoryCalculator == true && $0.isTemporarilyDeleted == false }.isEmpty {
                                    noFactoryCalculatorsPlaceholderButton
                                } else {
                                    factoryCalculatorList
                                }
                            }
                    }
                    .listStyle(.insetGrouped)
                    .environment(\.defaultMinListRowHeight, AppConfig.List.minListRowHeight)
                    .navigationBarTitle("CalculatorList.Title")
                    
                    //
                    .toolbar(content: toolbarContent)
                }
                .sheet(isPresented: $presentingNewCalculatorSheet) {
                    CalculatorEditView()
                }
                .sheet(isPresented: $presentingResultsSheet) {
                    ResultListScreen()
                }
                .sheet(isPresented: $presentingSettingsSheet) {
                    SettingsScreen()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: View components
    
    var headerBackground: some View {
        ZStack {
            LinearGradient(Color.mainGradientStart, Color.mainGradientEnd)
            //
            LinearGradient(gradient: Gradient(colors: [.white.opacity(0.2), .white.opacity(0)]),
                startPoint: .top,
                endPoint: .bottom)
        }
        .ignoresSafeArea(edges: .top)
        .frame(height: 0)
    }
    
    var noUserCalculatorsPlaceholderButton: some View {
        Button {
            displayNewCalculatorSheet()
        } label: {
            Label("CalculatorList.NoUserCalculatorsButton", systemImage: "plus")
        }
    }
    
    var noFactoryCalculatorsPlaceholderButton: some View {
        Button {
            Calculator.restoreFactoryCalculators(context: viewContext)
        } label: {
            Text("CalculatorList.NoFactoryCalculatorsButton")
        }
    }
                                  
    var userCalculatorList: some View {

        ForEach(calculators.filter { $0.isFactoryCalculator == false && $0.isTemporarilyDeleted == false }) { calculator in
            NavigationLink(destination: CalculatorScreen(calculatorVM: CalculatorViewModel(calculator: calculator))) {
                CalculatorListRowView(calculator: calculator)
            }
            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                Button("CalculatorList.CopyAction", role: .none) {
                    duplicate(calculator)
                }
                .tint(.green)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button("CalculatorList.DeleteAction", role: .destructive) {
                    deleteIndividual(calculator)
                }
            }
        }
        .listRowBackground(LinearGradient(Color.mainGradientStart, Color.mainGradientEnd))
    }
    
    var factoryCalculatorList: some View {
        
        ForEach(calculators.filter { $0.isFactoryCalculator == true && $0.isTemporarilyDeleted == false }) { calculator in
            NavigationLink(destination: CalculatorScreen(calculatorVM: CalculatorViewModel(calculator: calculator))) {
                CalculatorListRowView(calculator: calculator)
            }
            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                Button("CalculatorList.CopyAction", role: .none) {
                    duplicate(calculator)
                }
                .tint(.green)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button("CalculatorList.DeleteAction", role: .destructive) {
                    deleteIndividual(calculator)
                }
            }
        }
        .listRowBackground(LinearGradient(Color.mainGradientStart, Color.mainGradientEnd))
    }
    
    // MARK: Toolbar
    
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                displayNewCalculatorSheet()
            } label: {
                Label("CalculatorList.Toolbar.New", systemImage: "plus")
                    .imageScale(.large)
                    .frame(width: 44, height: 44, alignment: .leading)
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                displayResultsSheet()
            } label: {
                Label("CalculatorList.Toolbar.Results", systemImage: "list.star")
            
                    .imageScale(.large)
                    .frame(width: 44, height: 44, alignment: .trailing)
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                displaySettingSheet()
            } label: {
                Label("CalculatorList.Toolbar.Settings", systemImage: "gear")
                    .imageScale(.large)
                    .frame(width: 44, height: 44, alignment: .trailing)
            }
        }
    }
    
    // MARK: View helper methods
    
    private func deleteIndividual(_ calculator: Calculator) {
        
        calculatorListVM.deleteIndividual(calculator, context: viewContext)
    }
    
    private func duplicate(_ calculator: Calculator) {
        
        calculatorListVM.duplicate(calculator, context: viewContext)
    }
    
    private func displayNewCalculatorSheet() {
        
        self.presentingNewCalculatorSheet = true
    }
    
    private func displayResultsSheet() {
        
        self.presentingResultsSheet = true
    }
    
    private func displaySettingSheet() {
        
        self.presentingSettingsSheet = true
    }
}
 
struct CalculatorListScreen_Previews: PreviewProvider {
    static var previews: some View {
        
        CalculatorListScreen()
            .environmentObject(CoreDataController.calculatorPreview)
            .preferredColorScheme(.dark)
            .environment(\.locale, .init(identifier: "en"))
        
        CalculatorListScreen()
            .environmentObject(CoreDataController.calculatorPreview)
            .preferredColorScheme(.dark)
            .environment(\.locale, .init(identifier: "fi"))
    }
}
