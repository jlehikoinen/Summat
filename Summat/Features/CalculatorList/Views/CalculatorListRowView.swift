//
//  CalculatorListRowView.swift
//  Summat
//
//  Created by Janne Lehikoinen on 16.1.2022.
//

import SwiftUI

struct CalculatorListRowView: View {
    
    @ObservedObject var calculator: Calculator
    
    var body: some View {
        HStack {
            Text(calculator.wrappedName)
                .fontWeight(.medium)
            Spacer()
            if calculator.userHasntSeenTheCalculator {
                Text(String(format: NSLocalizedString("CalculatorListRow.NewCalculatorLabel", comment: "New calculator label")).uppercased())
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
                    .padding(.trailing, 10)
            }
        }
    }
}

struct CalculatorListRowView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorListRowView(calculator: .sample)
    }
}
