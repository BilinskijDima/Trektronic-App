//
//  StatisticsViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 18.06.23.
//

import Foundation
import HealthKit
import SwiftUI

final class StatisticsViewModel: ObservableObject  {
    
    @AppStorage("stateLoadHealthKit") var stateLoadHealthKit = DefaultSettings.stateLoadHealthKit
    @AppStorage("userID") var userID = DefaultSettings.userID
    
    var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    var healthKitManager: HealthKitManagerProtocol = HealthKitManager()
    
    @Published var stepsWeek: [HealthKitModel] = [HealthKitModel]()
    @Published var steps: Float = 0
    @Published var distance = 0
    
    @Published var selectedTab = "Шаги"
    var tabs = ["Шаги", "Дистанция"]
    
    func calculateData() {
        guard healthKitManager.healthStore != nil else {return}
        Task {
            
            guard let data = try await fireBaseManager.getData(id: userID).registrationDate, let dataWeek = Calendar.current.date(byAdding: .day, value: -6, to: Date()) else {return}
            
            if stateLoadHealthKit {
                guard let steps = HKQuantityType.quantityType(forIdentifier: .stepCount),
                      let distance = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
                      let calculateSteps = try await healthKitManager.calculateData(startDate: data, dataType: steps),
                      let calculateStepsWeek = try await healthKitManager.calculateData(startDate: dataWeek, dataType: steps),
                      let calculateDistance = try await healthKitManager.calculateData(startDate: data, dataType: distance) else {return}
                
                self.updateUIFromStatistics(calculateSteps, calculateDistance, calculateStepsWeek)
            }
        }
    }
    
  
    func updateUIFromStatistics(_ statisticsCollectionStep: HKStatisticsCollection,_ statisticsCollectionDistance: HKStatisticsCollection,_ statisticsCollectionStepWeek: HKStatisticsCollection) {
        
        guard let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date()) else {return}
        
        Task {
            guard let data = try await fireBaseManager.getData(id: userID).registrationDate else {return}
            
            let endDate = Date()
            
            await MainActor.run {
                statisticsCollectionStep.enumerateStatistics(from: data, to: endDate) { [weak self] (statistics, stop) in
                    
                    guard let self = self else {return}
                    
                    let count = statistics.sumQuantity()?.doubleValue(for: .count())
                    
                    self.steps = Float(count ?? 0.0)
                    
                }
                
                statisticsCollectionStepWeek.enumerateStatistics(from: startDate, to: endDate) { [weak self] (statistics, stop) in
                    
                    guard let self = self else {return}
                    
                    let count = statistics.sumQuantity()?.doubleValue(for: .count())
                    
                    let stepWeek = HealthKitModel(count: Int(count ?? 0), date: statistics.startDate)
                    
                    self.stepsWeek.append(stepWeek)
                    
                }
                
                statisticsCollectionDistance.enumerateStatistics(from: data, to: endDate) { [weak self] (statistics, stop) in
                    
                    guard let self = self else {return}
                    
                    let count = statistics.sumQuantity()?.doubleValue(for: HKUnit.meter())
                    
                    self.distance = Int(count ?? 0.0)
                    
                }
            }
        }
    }
    
}

