//
//  CalculatorButtonView.swift
//  Summat
//
//  Created by Janne Lehikoinen on 15.3.2022.
//

import SwiftUI

struct CalculatorButtonView: View {
    
    @State var showCalculatorButtons: Bool = false
    @ObservedObject var calculatorVM: CalculatorViewModel
    @AppStorage(UserSettings.enableCalculatorEntranceAnimationKey) var enableCalculatorEntranceAnimation: Bool = true
    
    //
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    //
    var index: Int
    var number: Int
    
    var body: some View {
        
        Button {
            calculatorVM.addToSum(number)
        } label: {
            Text(String(number))
                .latoFont(.buttonTitleBold)
                .foregroundStyle(
                    .linearGradient(
                        colors: [.blue, .cyan],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(
                    minWidth: AppConfig.ButtonSize.minWidthiPhone,
                    minHeight: AppConfig.ButtonSize.minHeightiPhone
                    )
        }
        .buttonStyle(DarkButtonStyle())
        .offset(y: showCalculatorButtons ? 0 : -800)
        .onAppear {
            if enableCalculatorEntranceAnimation {
                withAnimation(.interpolatingSpring(stiffness: 200, damping: 15).delay(Double(index) * 0.05)) {
                    showCalculatorButtons = true
                }
            } else {
                showCalculatorButtons = true
            }
        }
    }
}

struct CalculatorButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorButtonView(calculatorVM: CalculatorViewModel(calculator: .sample), index: 2, number: 100)
    }
}
