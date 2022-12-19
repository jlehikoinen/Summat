//
//  CalculatorButtonDraftView.swift
//  Summa
//
//  Created by Janne Lehikoinen on 15.3.2022.
//

import SwiftUI

struct CalculatorButtonDraftView: View {
    
    //
    @ObservedObject var calculatorEditVM: CalculatorEditViewModel
    
    //
    @State var showNewButtonDraft: Bool = false
    
    //
    var index: Int
    
    var body: some View {
        
        let _ = print(calculatorEditVM.buttonTitles.count, index)
        
        // If onDecrement pushed => Fatal error: Index out of range
        TextField(AppConfig.CalculatorEdit.buttonTitlePlaceholder, text: $calculatorEditVM.buttonTitles[index].text)
            .foregroundColor(calculatorEditVM.buttonTitles[index].hasReachedLimit ? .red : .primary)
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            .keyboardType(.numberPad)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .frame(width: AppConfig.ButtonSize.minWidth, height: AppConfig.ButtonSize.minHeight, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(
                        style: calculatorEditVM.buttonTitles[index].isCharCountWithinBoundaries ?
                        StrokeStyle(lineWidth: 2) : StrokeStyle(lineWidth: 2, dash: [8]))
            )
            .offset(x: showNewButtonDraft ? 0 : 500)
            .onAppear {
                withAnimation(.interpolatingSpring(stiffness: 200, damping: 15).delay(Double(index) * 0.05)) {
                    showNewButtonDraft = true
                }
            }
    }
}

struct CalculatorButtonDraftView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorButtonDraftView(calculatorEditVM: CalculatorEditViewModel(), index: 0)
    }
}
