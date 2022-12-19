//
//  ResultDetailView.swift
//  Summat
//
//  Created by Janne Lehikoinen on 9.2.2022.
//

import CoreData
import SwiftUI

struct ResultDetailView: View {
    
    //
    @ObservedObject var resultDetailVM: ResultDetailViewModel
    
    // Core Data
    @Environment(\.managedObjectContext) var viewContext
    
    //
    @State var attributedText = NSMutableAttributedString(string: "")
    
    //
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            Form {
                Section(header: Text("ResultDetail.Header.Name")) {
                    TextField("ResultDetail.PlaceholderName", text: $resultDetailVM.resultSaveName)
                }
                Section(header: Text("ResultDetail.Header.Result")) {
                    Text(resultDetailVM.userCalculation.wrappedResult)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
                Section(header: Text("ResultDetail.Header.CalculationElements")) {
                    Text(resultDetailVM.userCalculation.wrappedCalculationElementsAsString)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
                Section(header: Text("ResultDetail.Header.Comment")) {
                    TextEditor(text: $resultDetailVM.userCalculation.comment ?? "")
                }
                HStack(alignment: .center) {
                    Spacer()
                    Button(action: saveCalculation) {
                        Text("ResultDetail.SaveButton")
                    }
                    .disabled(resultDetailVM.resultSaveName.isEmpty)
                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 6) {
                    Text(resultDetailVM.userCalculation.wrappedCalculatorName)
                        .font(.headline)
                    Text(resultDetailVM.userCalculation.wrappedSavedTimeLongFormat)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
        .onAppear {
            // Handle optional Core Data values when view loads
            resultDetailVM.handleExistingProperties()
        }
    }
    
    // MARK: CRUD methods
    
    private func saveCalculation() {
    
        resultDetailVM.saveCalculation(for: resultDetailVM.userCalculation, context: viewContext)
        dismiss()
    }
}

struct ResultDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResultDetailView(resultDetailVM: ResultDetailViewModel(userCalculation: .sample))
                .preferredColorScheme(.dark)
                .environment(\.locale, .init(identifier: "en"))

            ResultDetailView(resultDetailVM: ResultDetailViewModel(userCalculation: .sample))
                .preferredColorScheme(.dark)
                .environment(\.locale, .init(identifier: "fi"))
        }
    }
}
