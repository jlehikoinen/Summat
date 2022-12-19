//
//  CalculatorViewModel.swift
//  Summat
//
//  Created by Janne Lehikoinen on 23.2.2022.
//

import AVKit
import CoreData
import CoreHaptics
import SwiftUI

class CalculatorViewModel: ObservableObject {
    
    //
    @AppStorage(UserSettings.enableButtonSoundsKey) var enableButtonSounds: Bool = true
    @AppStorage(UserSettings.enableHapticFeedbackKey) var enableHapticFeedback: Bool = true
    
    //
    private var player: AVAudioPlayer?
    private var engine: CHHapticEngine?
    private var buttonLayout = ButtonLayout()
    
    //
    @Published var calculator: Calculator
    @Published var calculationElements = [Int]()
    @Published var totalSum = 0
    @Published var buttonsInVerticalOrder = false
    @Published var calculationElementsAnimating: Bool = false
    @Published var gridColumns = [GridItem]()
    @Published var buttonNumbers = [Int]()
    
    // Compose columns every time buttonTitles change
    // Workaround for updating column layout when edit view is dismissed
    @Published var buttonTitles = [CalculatorButtonTitle]() {
        didSet {
            composeColumns()
        }
    }
    
    //
    init(calculator: Calculator) {
        
        self.calculator = calculator
        buttonNumbers = calculator.wrappedButtonNumbers
        buttonTitles = calculator.wrappedButtonNumbers.map { CalculatorButtonTitle(isCharCountWithinBoundaries: true, text: String($0)) }
    }
    
    // MARK: Public methods
    
    func animateCalculationElements() {
        calculationElementsAnimating.toggle()
    }
    
    func addToSum(_ number: Int) {
        
        //
        if enableButtonSounds { playSound(name: "Cork01", volume: 1.0) }
        if enableHapticFeedback { simpleSuccess() }
        
        //
        calculationElements.append(number)
        totalSum += number
        NSLog("Adding \(number) to the total sum. Total sum: \(totalSum)")
        
        //
        self.animateCalculationElements()
    }
    
    func removeLastDigit() {
        
        guard !calculationElements.isEmpty else { return }
        
        //
        if enableButtonSounds { playSound(name: "Tape02", volume: 0.2) }
        if enableHapticFeedback { simpleSuccess() }
        
        totalSum -= calculationElements.last!
        NSLog("Removing last digit and subtractiong total sum. Total sum: \(totalSum)")
        calculationElements.removeLast()
        
        //
        self.animateCalculationElements()
    }
    
    func resetSum() {
        
        NSLog("Resetting total sum")
        
        //
        if enableButtonSounds { playSound(name: "Tube03", volume: 0.8) }
        if enableHapticFeedback { simpleSuccess() }
        
        totalSum = 0
        calculationElements.removeAll()
        
        //
        self.animateCalculationElements()
    }
    
    func resetLayout() {
        
        buttonsInVerticalOrder = false
        buttonNumbers.sort()
    }
    
    func saveButtonsLayout(for context: NSManagedObjectContext) {
     
        buttonsInVerticalOrder.toggle()
        NSLog("Toggled verticalLayout: \(buttonsInVerticalOrder)")
        
        if buttonsInVerticalOrder {
            changeButtonLayoutToVertical()
        } else {
            buttonNumbers.sort()
        }
    }
    
    func userHasSeenTheNewCalculator(_ calculator: Calculator, context: NSManagedObjectContext) {
        
        if let existingCalculator = Calculator.fetchCalculator(for: calculator.objectID, context: context) {
            existingCalculator.userHasntSeenTheCalculator = false
        }
        
        // Save to Core Data
        do {
            try context.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Layout
    
    func composeColumns() {
        gridColumns = buttonLayout.composeColumns(with: buttonTitles)
    }
    
    func changeButtonLayoutToVertical() {
        buttonNumbers = buttonLayout.changeOrderToVertical(buttonNumbers)
    }
    
    // MARK: UserCalculation CRUD Methods
    
    func saveNewResult(context: NSManagedObjectContext) {
        
        let newUserCalculation = UserCalculation(context: context)
        newUserCalculation.id = UUID()
        newUserCalculation.calculatorName = calculator.wrappedName
        newUserCalculation.savedTime = Date.now
        newUserCalculation.calculationElements = calculationElements as NSObject
        newUserCalculation.result = Int32(totalSum)
        
        // Save to Core Data
        do {
            try context.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
        }
        
        resetSum()
    }
    
    // MARK: Sounds
    
    private func playSound(name: String, volume: Float) {
        
        if let asset = NSDataAsset(name: name) {
            do {
                player = try AVAudioPlayer(data: asset.data, fileTypeHint: "caf")
                player?.volume = volume
                player?.play()
            } catch {
                NSLog("Couldn't load audio file")
            }
        } else {
            NSLog("Audio file not found")
        }
    }
    
    // MARK: Haptics
    
    func prepareSoundsAndHaptics() {

        // Workaround for audio latency when first button is pushed
        if enableButtonSounds { playSound(name: "Tape02", volume: 0.0) }
        
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            NSLog("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    private func simpleSuccess() {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
