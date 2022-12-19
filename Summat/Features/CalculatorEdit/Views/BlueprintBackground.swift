//
//  BlueprintBackground.swift
//  Summat
//
//  Created by Janne Lehikoinen on 5.2.2022.
//

import SwiftUI

struct BlueprintBackground: View {
    
    var cellWidth: Int = 10
    var cellHeight: Int = 10
    var narrowLineWidth: Int = 1
    var wideLineWidth: Int = 2
    var wideLineDistribution: Int = 5
    var gridColor: Color = .mainGradientStart
    var linearGradientBgStart: Color = .mainGradientStart
    var linearGradientBgEnd: Color = .mainGradientEnd
    
    var body: some View {
        
        ZStack {
            LinearGradient(linearGradientBgStart, linearGradientBgEnd)
            backgroundGrid
        }
    }
    
    var backgroundGrid: some View {
        
        GeometryReader { gr in
            let numberOfHorizontalLines = Int(gr.size.height / CGFloat(self.cellHeight))
            let numberOfVerticalLines = Int(gr.size.width / CGFloat(self.cellWidth))
            
            // Vertical lines
            ForEach(0...numberOfVerticalLines, id: \.self) { index in
                
                // Skip first iteration
                let offSetIndex = index + 1
                
                // Skip last iteration
                if index != numberOfVerticalLines {
                
                    // Wide line
                    if index == 0 || index.isMultiple(of: wideLineDistribution) {
                        Path { path in
                        
                            let verticalOffset: CGFloat = CGFloat(offSetIndex) * CGFloat(self.cellWidth)
                            path.move(to: CGPoint(x: verticalOffset, y: 0))
                            path.addLine(to: CGPoint(x: verticalOffset, y: gr.size.height))
                        }
                        .stroke(gridColor, lineWidth: CGFloat(wideLineWidth))
                    } else {
                        // Narrow line
                        Path { path in
                            let verticalOffset: CGFloat = CGFloat(offSetIndex) * CGFloat(self.cellWidth)
                            path.move(to: CGPoint(x: verticalOffset, y: 0))
                            path.addLine(to: CGPoint(x: verticalOffset, y: gr.size.height))
                        }
                        .stroke(gridColor, lineWidth: CGFloat(narrowLineWidth))
                    }
                }
            }
            
            // Horizontal lines
            ForEach(0...numberOfHorizontalLines, id: \.self) { index in
                
                // Skip first iteration
                let offSetIndex = index + 1
                
                // Skip last iteration
                if index != numberOfHorizontalLines {
                
                    // Wide line
                    if index == 0 || index.isMultiple(of: wideLineDistribution) {
                        Path { path in
                            let horizontalOffset: CGFloat = CGFloat(offSetIndex) * CGFloat(self.cellHeight)
                            path.move(to: CGPoint(x: 0, y: horizontalOffset))
                            path.addLine(to: CGPoint(x: gr.size.width, y: horizontalOffset))
                        }
                        .stroke(gridColor, lineWidth: CGFloat(wideLineWidth))
                    } else {
                        // Narrow line
                        Path { path in
                            let horizontalOffset: CGFloat = CGFloat(offSetIndex) * CGFloat(self.cellHeight)
                            path.move(to: CGPoint(x: 0, y: horizontalOffset))
                            path.addLine(to: CGPoint(x: gr.size.width, y: horizontalOffset))
                        }
                        .stroke(gridColor, lineWidth: CGFloat(narrowLineWidth))
                    }
                }
            }
        }
    }
}

struct BuilderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ColorScheme.allCases, id: \.self) {
                BlueprintBackground()
                .environmentObject(CoreDataController.calculatorPreview)
                .preferredColorScheme($0)
            }
        }
    }
}
