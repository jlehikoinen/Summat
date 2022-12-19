//
//  DismissSheetButton.swift
//  Summat
//
//  Created by Janne Lehikoinen on 28.7.2022.
//

import SwiftUI

struct DismissSheetButton: View {
    var body: some View {
        Image(systemName: "xmark.circle.fill")
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.secondary)
            .font(.title3)
    }
}

struct DismissSheetButton_Previews: PreviewProvider {
    static var previews: some View {
        DismissSheetButton()
    }
}
