//
//  CalculatorEditView.swift
//  Summat
//
//  Created by Janne Lehikoinen on 14.1.2022.
//

import CoreData
import SwiftUI

struct CalculatorEditView: View {
    
    //
    var calculatorId: NSManagedObjectID?
    
    //
    @ObservedObject var calculatorEditVM = CalculatorEditViewModel()
    @FocusState var isNameFieldFocused: Bool
    @Environment(\.managedObjectContext) var viewContext
    
    //
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            ZStack {
                
                BlueprintBackground()
                
                VStack {
                    
                    toolbar
                    
                    ZStack {
    
                        roundedRectangleBox
                        
                        TextField("CalculatorEdit.PlaceholderName", text: $calculatorEditVM.calculatorName)
                            .focused($isNameFieldFocused)
                            .font(.body.bold())
                            .padding()
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    
                    ZStack {
                        
                        roundedRectangleBox
                        
                        Stepper("CalculatorEdit.NumberOfButtons \(calculatorEditVM.buttonTitles.count)",
                                onIncrement: {
                            calculatorEditVM.increment()
                        },
                                onDecrement: {
                            calculatorEditVM.decrement()
                        }
                        )
                        // Handle iPod case => smaller font so the text fits
                        .font(UIDevice.isiPod ? .footnote.bold() : .body.bold())
                        .foregroundColor(.secondary)
                        .padding()
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    
                    Spacer()
                    buttonBlueprints
                        .dynamicTypeSize(...DynamicTypeSize.medium)
                        .padding(.top)
                    Spacer()
                }
            }
        }
        .onAppear {
            //
            handleExistingCalculatorProperties()
            
            //
            calculatorEditVM.composeColumns()
            
            // This artificial delay is required for focus state
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isNameFieldFocused = true
            }
        }
    }
    
    // MARK: View components
    
    var toolbar: some View {
        
        HStack {
            Button {
                dismiss()
            } label: {
                Text("CalculatorEdit.CancelButton")
            }
            
            Spacer()
            
            if calculatorId == nil {
                Text("CalculatorEdit.TitleNewCalculator")
                    .fontWeight(.semibold)
            } else {
                Text("CalculatorEdit.TitleEditCalculator")
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            Button {
                addNewCalculatorVsSaveExisting()
            } label: {
                Text("CalculatorEdit.SaveButton")
                    .fontWeight(.semibold)
            }
            .disabled(!calculatorEditVM.isComposedCalculatorValid)
        }
        .padding(.top)
        .padding(.horizontal)
    }
    
    var roundedRectangleBox: some View {
        
        Color.mainGradientEnd
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .opacity(0.4)
            .blendMode(.softLight)
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(lineWidth: 1)
                        .fill(.black.opacity(0.2)))
    }
    
    var buttonBlueprints: some View {
        
        LazyVGrid(columns: calculatorEditVM.gridColumns, spacing: 4) {
            ForEach(calculatorEditVM.buttonTitles.indices, id: \.self) { index in
                TextField(AppConfig.CalculatorEdit.buttonTitlePlaceholderEmpty, text: $calculatorEditVM.buttonTitles[index].text)
                    .foregroundColor(calculatorEditVM.buttonTitles[index].hasReachedLimit ? .red : .primary)
                    .latoFont(.bodyLargerBold)
                    .keyboardType(.numberPad)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .frame(
                        width: AppConfig.ButtonSize.minWidthiPhone,
                        height: AppConfig.ButtonSize.minHeightiPhone,
                        alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(
                                style: calculatorEditVM.buttonTitles[index].isCharCountWithinBoundaries ?
                                StrokeStyle(lineWidth: 2) : StrokeStyle(lineWidth: 2, dash: [8]))
                    )
            }
            .padding(5)
        }
    }
    
    // MARK: View helper methods
    
    private func handleExistingCalculatorProperties() {
        
        // This handles new vs. edit scenario
        guard let objectId = calculatorId,
              let calculator = Calculator.fetchCalculator(for: objectId, context: viewContext)
        else { return }
        
        calculatorEditVM.calculatorName = calculator.wrappedName
        calculatorEditVM.buttonTitles = calculator.wrappedButtonNumbers.map { CalculatorButtonTitle(isCharCountWithinBoundaries: true, text: String($0)) }
    }
    
    // MARK: CRUD methods
    
    private func addNewCalculatorVsSaveExisting() {
        
        calculatorEditVM.addNewCalculatorVsSaveExisting(objectId: calculatorId, context: viewContext)
        dismiss()
    }
}

//struct CalculatorEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalculatorEditView(calculatorEditVM: CalculatorEditViewModel())
//    }
//}
