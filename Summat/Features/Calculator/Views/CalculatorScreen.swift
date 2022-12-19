//
//  CalculatorScreen.swift
//  Summat
//
//  Created by Janne Lehikoinen on 14.1.2022.
//

import SwiftUI

struct CalculatorScreen: View {
    
    @ObservedObject var calculatorVM: CalculatorViewModel
    
    // Core Data
    @Environment(\.managedObjectContext) var viewContext
    
    // Sheets
    @State private var presentingResetActionSheet: Bool = false
    @State private var presentingSaveActionSheet: Bool = false
    @State private var presentingEditSheet: Bool = false
    @State private var presentingResultsSheet: Bool = false
    
    //
    @State private var buttonsOrderAnimating: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(Color.mainGradientStart, Color.mainGradientEnd)
                .ignoresSafeArea()
        
            GeometryReader { gr in
                VStack(alignment: .center, spacing: 0) {
                    totalSumView
                        .dynamicTypeSize(...DynamicTypeSize.medium)
                        .frame(maxHeight: 120)
                        .padding(.top, gr.size.height * 0.02)
                        .padding(.bottom)
                    
                    buttonLayout
                        .dynamicTypeSize(...DynamicTypeSize.medium)
                    
                    Divider()
                    footerButtonsView
                        .padding()
                }
                .toolbar(content: toolbarContent)
                .navigationBarTitle(calculatorVM.calculator.wrappedName, displayMode: .inline)
                .sheet(isPresented: $presentingEditSheet) {
                    CalculatorEditView(calculatorId: calculatorVM.calculator.objectID)
                }
                .sheet(isPresented: $presentingResultsSheet) {
                    ResultListScreen()
                }
            }
        }
        .onAppear {
            calculatorVM.prepareSoundsAndHaptics()
            composeColumns()
            resetLayoutWhenViewLoaded()
            userHasSeenTheNewCalculator()
        }
    }
    
    // MARK: View components
    
    var headerBg: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .fill(LinearGradient(colors: [.mainGradientEnd, .mainGradientStart], startPoint: .topLeading, endPoint: .bottomTrailing))
            .shadow(color: Color.mainGradientEnd, radius: 4, x: -4, y: -4)
            .shadow(color: Color.mainGradientStart, radius: 4, x: 4, y: 4)
            .padding(.horizontal)
    }
    
    var totalSumView: some View {
        ZStack {
            
            headerBg
            
            VStack(alignment: .center) {
                HStack {
                    Text(String(calculatorVM.calculationElements.count))
                        .foregroundColor(.secondary)
                        // .font(.body)
                        .latoFont(.bodyRegular)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.secondary, lineWidth: 2)
                        )
                    Spacer()
                    Text(String(calculatorVM.totalSum))
                        .foregroundColor(.primary)
                        // .font(.system(size: 50))
                        .latoFont(.hugeTitle)
                        .onTapGesture {
                            calculatorVM.removeLastDigit()
                        }
                }
                .frame(maxHeight: .infinity, alignment: .center)
                
                calculationElementsView
                    .frame(maxHeight: .infinity, alignment: .center)
                    .animation(.easeInOut, value: calculatorVM.calculationElementsAnimating)
            }
            .padding(.horizontal, 30)
            .padding(.vertical)
        }
    }
    
    var calculationElementsView: some View {
        ScrollView(.horizontal) {
            
            // Placeholder string
            if calculatorVM.calculationElements.count == 0  {
                Text("---")
            }
            
            ScrollViewReader { proxy in
                HStack {
                    ForEach(Array(zip(calculatorVM.calculationElements.indices, calculatorVM.calculationElements)), id: \.0) { index, number in
                        if index == calculatorVM.calculationElements.count - 1 {
                            Text(String(number))
                                .id(index)
                                .foregroundColor(.primary)
                                .latoFont(.bodyRegularBold)
                        } else {
                            Group {
                                Text("\(String(number))")
                                    .id(index)
                                    .foregroundColor(.secondary)
                                    .latoFont(.bodyRegular)
                            }
                        }
                    }
                }
                .onChange(of: calculatorVM.calculationElements.count) { count in
                    withAnimation {
                        proxy.scrollTo(count - 1)
                    }
                }
                .padding(.trailing)
            }
        }
    }
    
    var buttonLayout: some View {
        
        GeometryReader { gr in
            // Center alignment workaround with ZStack because GeometryReader uses
            // top-leading alignment by default
            ZStack {
                LazyVGrid(columns: calculatorVM.gridColumns, alignment: .center, spacing: gr.size.height * 0.05) {
                    ForEach(Array(zip(calculatorVM.buttonNumbers.indices, calculatorVM.buttonNumbers)), id: \.1) { index, number in
                        CalculatorButtonView(calculatorVM: calculatorVM, index: index, number: number)
                    }
                }
                .animation(.easeInOut, value: buttonsOrderAnimating)
            }
            .frame(width: gr.size.width, height: gr.size.height, alignment: .center)
        }
    }
    
    var footerButtonsView: some View {
        
        HStack(alignment: .center) {
            
            Button {
                presentingResetActionSheet = true
            } label: {
                Text(String(format: NSLocalizedString("Calculator.FooterButtons.Reset", comment: "Reset button title")).uppercased())
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(calculatorVM.calculationElements.isEmpty ? .secondary : .red)
                    .frame(minWidth: 90, minHeight: 44)
            }
            .confirmationDialog("Calculator.FooterButtons.ResetConfirmation", isPresented: $presentingResetActionSheet, titleVisibility: .visible) {
                Button("Calculator.FooterButtons.Reset", role: .destructive) {
                    calculatorVM.resetSum()
                }
            }
            .disabled(calculatorVM.calculationElements.isEmpty)
            .buttonStyle(DarkButtonStyleFooter())
            
            Spacer()
            
            Button {
                calculatorVM.removeLastDigit()
            } label: {
                Text(String(format: NSLocalizedString("Calculator.FooterButtons.Undo", comment: "Undo button title")).uppercased())
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(calculatorVM.calculationElements.isEmpty ? .secondary : .yellow)
                    .frame(minWidth: 90, minHeight: 44)
            }
            .disabled(calculatorVM.calculationElements.isEmpty)
            .buttonStyle(DarkButtonStyleFooter())
            
            Spacer()
            
            Button {
                presentingSaveActionSheet = true
            } label: {
                Text(String(format: NSLocalizedString("Calculator.FooterButtons.Save", comment: "Save button title")).uppercased())
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(calculatorVM.calculationElements.isEmpty ? .secondary : .green)
                    .frame(minWidth: 90, minHeight: 44)
            }
            .confirmationDialog("Calculator.FooterButtons.SaveConfirmation", isPresented: $presentingSaveActionSheet, titleVisibility: .visible) {
                Button("Calculator.FooterButtons.Save") {
                    saveResult()
                }
            }
            .disabled(calculatorVM.calculationElements.isEmpty)
            .buttonStyle(DarkButtonStyleFooter())
        }
    }
    
    // MARK: Toolbar
    
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                toggleGridItemLayout()
            } label: {
                Label("Calculator.Toolbar.Order", systemImage: calculatorVM.buttonsInVerticalOrder ? "arrow.left.arrow.right" : "arrow.up.arrow.down")
            }
            .disabled(calculatorVM.buttonNumbers.count <= AppConfig.Limits.maxNumberOfRows)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                displayEditCalculatorSheet()
            } label: {
                Label("Calculator.Toolbar.Edit", systemImage: "square.and.pencil")
            }
        }
    }
    
    // MARK: Layout
    
    // Temp workaround
    private func resetLayoutWhenViewLoaded() {
        
        calculatorVM.resetLayout()
    }
    
    private func toggleGridItemLayout() {
        
        //
        buttonsOrderAnimating.toggle()
        
        //
        calculatorVM.saveButtonsLayout(for: viewContext)
    }
    
    private func composeColumns() {
        
        calculatorVM.composeColumns()
    }
    
    // MARK: View helper methods
    
    private func displayEditCalculatorSheet() {
        
        presentingEditSheet = true
    }
    
    private func saveResult() {
        
        calculatorVM.saveNewResult(context: viewContext)
        presentingResultsSheet = true
    }
    
    private func userHasSeenTheNewCalculator() {
        
        calculatorVM.userHasSeenTheNewCalculator(calculatorVM.calculator, context: viewContext)
    }
}

struct CalculatorScreen_Previews: PreviewProvider {
    static var previews: some View {
        
        CalculatorScreen(calculatorVM: CalculatorViewModel(calculator: .sample))
            .preferredColorScheme(.dark)
            .environment(\.locale, .init(identifier: "fi"))
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
            .previewDisplayName("iPhone 13 Pro Max")
    }
}
