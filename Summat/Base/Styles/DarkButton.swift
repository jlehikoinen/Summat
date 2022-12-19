//
//  DarkButton.swift
//  Summat
//
//  Created by Janne Lehikoinen on 21.2.2022.
//

import SwiftUI

struct DarkBackground<S: Shape>: View {
    
    var isHighlighted: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(colors: [.mainGradientEnd, .mainGradientStart], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(shape.stroke(LinearGradient(Color.blueStart, Color.cyanEnd), lineWidth: 1))
            } else {
                shape
                    .fill(LinearGradient(colors: [.mainGradientEnd, .mainGradientStart], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(shape.stroke(LinearGradient(colors: [.mainGradientStart, .mainGradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1))
                    .shadow(color: Color.mainGradientStart, radius: 4, x: -4, y: -4)
                    .shadow(color: Color.mainGradientEnd, radius: 4, x: 4, y: 4)
            }
        }
    }
}

struct DarkBackgroundFooter<S: Shape>: View {
    
    var isHighlighted: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(colors: [.mainGradientEnd, .mainGradientStart], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(shape.stroke(LinearGradient(Color.mainGradientStart, Color.mainGradientEnd), lineWidth: 1))
            } else {
                shape
                    .fill(LinearGradient(colors: [.mainGradientEnd, .mainGradientStart], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(shape.stroke(LinearGradient(colors: [.mainGradientStart, .mainGradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1))
                    .shadow(color: Color.mainGradientStart, radius: 2, x: -2, y: -2)
                    .shadow(color: Color.mainGradientEnd, radius: 2, x: 2, y: 2)
            }
        }
    }
}

struct DarkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .contentShape(RoundedRectangle(cornerRadius: 14))
            .background(
                DarkBackground(isHighlighted: configuration.isPressed, shape: RoundedRectangle(cornerRadius: 14))
            )
    }
}

struct DarkButtonStyleFooter: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .background(
                DarkBackgroundFooter(isHighlighted: configuration.isPressed, shape: RoundedRectangle(cornerRadius: 10))
            )
    }
}
