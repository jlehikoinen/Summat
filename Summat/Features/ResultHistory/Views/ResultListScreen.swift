//
//  ResultListScreen.swift
//  Summat
//
//  Created by Janne Lehikoinen on 14.1.2022.
//

import SwiftUI

struct ResultListScreen: View {
    
    let resultListVM = ResultListViewModel()
    
    //
    @State var monthAndYearSections = [String]()
    
    // Core Data
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.savedTime, order: .reverse)], animation: .default) var userCalculations: FetchedResults<UserCalculation>
    @Environment(\.managedObjectContext) var viewContext
    
    //
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            if userCalculations.isEmpty {
                noResultsPlaceholder
            } else {
                resultList
                    .navigationBarTitle("ResultList.Title")
            }
        }
        .onAppear {
            prepareSections()
        }
    }
    
    // MARK: View components
    
    var noResultsPlaceholder: some View {
        
        VStack {
            Image(systemName: "list.star")
                .font(.largeTitle)
                .foregroundColor(.secondary)
                .padding()
            Text("ResultList.NoResultsPlaceholder")
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
        .toolbar {
            toolbarContent()
        }
    }
    
    var resultList: some View {
        
        List {
            ForEach(monthAndYearSections, id:\.self) { monthAndYear in
                Section(header: Text(monthAndYear)) {
                    ForEach(userCalculations.filter { $0.wrappedMonthAndYear == monthAndYear } ) { userCalculation in
                        NavigationLink(destination: ResultDetailView(resultDetailVM: ResultDetailViewModel(userCalculation: userCalculation)))  {
                            ResultListRowView(userCalculation: userCalculation)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button("ResultList.DeleteButton", role: .destructive) {
                                delete(userCalculation)
                            }
                        }
                    }
                }
            }
            .listRowBackground(LinearGradient(Color.mainGradientStart, Color.mainGradientEnd))
        }
        .toolbar {
            toolbarContent()
        }
    }
    
    var closeSheetButton: some View {
        Button {
            dismiss()
        } label: {
            DismissSheetButton()
        }
    }
    
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            closeSheetButton
        }
    }
    
    // MARK: View helper methods
    
    private func delete(_ calculation: UserCalculation) {
            
        resultListVM.deleteIndividual(calculation, context: viewContext)
    }
    
    private func prepareSections() {
        
        let listOfMonthsAndYears = userCalculations.map { $0.wrappedMonthAndYear }
        monthAndYearSections = resultListVM.sortMonths(monthsAndYears: listOfMonthsAndYears)
    }
}

struct ResultListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ResultListScreen()
            .preferredColorScheme(.dark)
            .environment(\.locale, .init(identifier: "en"))
        
        ResultListScreen()
            .preferredColorScheme(.dark)
            .environment(\.locale, .init(identifier: "fi"))
    }
}
