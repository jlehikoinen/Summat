//
//  ResultListRowView.swift
//  Summat
//
//  Created by Janne Lehikoinen on 9.2.2022.
//

import SwiftUI

struct ResultListRowView: View {
    
    var userCalculation: UserCalculation
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(userCalculation.wrappedSaveName)
                    .foregroundColor(.primary)
                    .font(.body)
                Text(userCalculation.wrappedCalculatorName)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .font(.footnote)
                Text(userCalculation.wrappedSavedTimeLongFormat)
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            
            Spacer()
            
            Text(userCalculation.wrappedResult)
                .foregroundColor(.primary)
                .font(.title2)
                .fontWeight(.semibold)
        }
    }
}

struct ResultListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ResultListRowView(userCalculation: .sample)
            .preferredColorScheme(.dark)
    }
}
