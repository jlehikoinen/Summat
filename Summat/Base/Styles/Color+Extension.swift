//
//  Color+Extension.swift
//  Summat
//
//  Created by Janne Lehikoinen on 6.3.2022.
//

import SwiftUI

extension Color {
    
    //
    static let mainGradientStart = Color("GradientStart")
    static let mainGradientEnd = Color("GradientEnd")
    
    //
    static let blueStart = Color(.blue)
    static let cyanEnd = Color(.cyan)
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
