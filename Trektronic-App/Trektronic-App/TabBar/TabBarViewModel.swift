//
//  TabBarViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import Foundation
import SwiftUI
import HealthKit
import Combine

enum Tab: String, CaseIterable {
    
    case house
    case chart = "chart.xyaxis.line"
    case person
    case gearshape
    
    var color: Color {
        switch self {
        case .house:
            return .gray
        case .chart:
            return .gray
        case .person:
            return .gray
        case .gearshape:
            return .gray
        }
    }
}

final class TabBarViewModel: ObservableObject  {
    
    private var cancellable = Set <AnyCancellable>()
    
    @Published var steps: Float = 0
    
    @Published var statisticsViewModel = StatisticsViewModel()
    
    init() {
        $steps
            .sink { [weak self] step in
                self?.statisticsViewModel.steps = step
            print ("sink \(step)")
        }
        .store(in: &cancellable)
    }
    
    @AppStorage("userID") var userID = DefaultSettings.userID
    
    private var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    private var healthKitManager: HealthKitManagerProtocol = HealthKitManager()
    
    @Published var selectedTab: Tab = .house
     
    var selectedColor: Color {
        switch selectedTab {
        case .house:
            return Color.red
        case .chart:
            return Color.green
        case .person:
            return Color.purple
        case .gearshape:
            return Color.blue
            
        }
    }
    let date = Calendar.current.startOfDay(for: Date())

    func calculateDataHealthKitStep() {
        guard healthKitManager.healthStore != nil, let steps = HKQuantityType.quantityType(forIdentifier: .stepCount)
        else {return}
        
        healthKitManager.getTodayStepsObserver(withStart: date, dataType: steps) {[weak self] result in
            guard let sum = result?.sumQuantity(), let self = self else {return}
            
            let resultStep = Float(sum.doubleValue(for: HKUnit.count()))
            
            updateSteps(value: Int(resultStep))
            
            DispatchQueue.main.async {
                self.steps = resultStep
            }
        }
    }
    
    func updateSteps(value: Int) {
        fireBaseManager.updateData(nameValueUpdate: "step", id: userID, value: value)
    }
    
    
    
    
}
