//
//  CalculatorListScreen2.swift
//  Summa
//
//  Created by Janne Lehikoinen on 13.3.2022.
//

import SwiftUI

struct CalculatorListScreen2: View {
    
    // TODO: @SectionedFetchRequest
    @Environment(\.managedObjectContext) private var viewContext
    
//    @SectionedFetchRequest(
//        sectionIdentifier: CalculatorSection.default.section,
//        sortDescriptors: CalculatorSection.default.descriptors,
//        animation: .default
//    )
    
//    @SectionedFetchRequest(entity: Calculator.entity(),
//                           sectionIdentifier: \.sectionName,
//                           sortDescriptors: [NSSortDescriptor(keyPath: \Calculator.savedTime, ascending: true)],
//                           predicate: nil,
//                           animation: .default)

    @SectionedFetchRequest<String,Calculator>(
        sectionIdentifier: \.sectionName,
        sortDescriptors: [SortDescriptor(\.savedTime, order: .reverse)]
    )
    
    var sections: SectionedFetchResults<String, Calculator>
    
    var body: some View {
        // Text("Hello")
        List {
            ForEach(sections) { section in
                Section(header: Text(section.id)) {
                    ForEach(section) { calculator in
                        Text(calculator.wrappedName)
                    }
                }
            }
        }
        .onAppear {
            print("Sections: \(sections)")
        }
    }
}

struct CalculatorListScreen2_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorListScreen2()
    }
}
