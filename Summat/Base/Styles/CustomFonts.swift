//
//  CustomFonts.swift
//  Summat
//
//  Created by Janne Lehikoinen on 7.4.2022.
//

import SwiftUI

struct LatoFont: ViewModifier {
    
    @Environment(\.sizeCategory) var sizeCategory
    
    public enum TextStyle {
        case hugeTitle
        case buttonTitleBold
        case bodyLarger
        case bodyLargerBold
        case bodyRegular
        case bodyRegularBold
        case bodySmall
    }
    
    var textStyle: TextStyle
    
    func body(content: Content) -> some View {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return content.font(.custom(fontName, size: scaledSize))
    }
    
    private var fontName: String {
        switch textStyle {
        case .hugeTitle:
            return "Lato-Regular"
        case .buttonTitleBold:
            return "Lato-Bold"
        case .bodyLarger:
            return "Lato-Regular"
        case .bodyLargerBold:
            return "Lato-Bold"
        case .bodyRegular:
            return "Lato-Regular"
        case .bodyRegularBold:
            return "Lato-Bold"
        case .bodySmall:
            return "Lato-Regular"
        }
    }
    
    private var size: CGFloat {
        switch textStyle {
        case .hugeTitle:
            return 50
        case .buttonTitleBold:
            return 24
        case .bodyLarger:
            return 20
        case .bodyLargerBold:
            return 20
        case .bodyRegular:
            return 18
        case .bodyRegularBold:
            return 18
        case .bodySmall:
            return 16
        }
    }
}

extension View {
    
    func latoFont(_ textStyle: LatoFont.TextStyle) -> some View {
        self.modifier(LatoFont(textStyle: textStyle))
    }
}
