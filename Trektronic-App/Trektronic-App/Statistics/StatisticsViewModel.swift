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
    
    func calculateData() {
        guard healthKitManager.healthStore != nil else {return}
        Task {
            
            guard let data = try await fireBaseManager.getData(id: userID).registrationDate, let dataWeek = Calendar.current.date(byAdding: .day, value: -6, to: Date()) else {return}
            
       
            if stateLoadHealthKit {
                guard let calculateSteps = try await healthKitManager.calculateData(startDate: data, dataType: HKQuantityType.init(HKQuantityTypeIdentifier.stepCount)),
                      let calculateStepsWeek = try await healthKitManager.calculateData(startDate: dataWeek, dataType: HKQuantityType.init(HKQuantityTypeIdentifier.stepCount)),
                      let calculateDistance = try await healthKitManager.calculateData(startDate: data, dataType: HKQuantityType.init(HKQuantityTypeIdentifier.distanceWalkingRunning)) else {return}
                
                self.updateUIFromStatistics(calculateSteps, calculateDistance, calculateStepsWeek)
            }
        }
    }
    
    func updateUIFromStatistics(_ statisticsCollectionStep: HKStatisticsCollection,_ statisticsCollectionDistance: HKStatisticsCollection,_ statisticsCollectionStepWeek: HKStatisticsCollection) {
        
        guard let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date()) else {return}
        
        Task {
            guard let data = try await fireBaseManager.getData(id: userID).registrationDate else {return}

            let endDate = Date()
            
            statisticsCollectionStep.enumerateStatistics(from: data, to: endDate) { (statistics, stop) in
                
                let count = statistics.sumQuantity()?.doubleValue(for: .count())
                
            
                
                DispatchQueue.main.async {
                    self.steps = Float(count ?? 0.0)
           
                }
                
            }
            
            statisticsCollectionStepWeek.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
                
                let count = statistics.sumQuantity()?.doubleValue(for: .count())
                
                let stepWeek = HealthKitModel(count: Int(count ?? 0), date: statistics.startDate)
                
                DispatchQueue.main.async {
                    self.stepsWeek.append(stepWeek)
                }
                
            }
            
            statisticsCollectionDistance.enumerateStatistics(from: data, to: endDate) { (statistics, stop) in
                
                let count = statistics.sumQuantity()?.doubleValue(for: HKUnit.meter())
                
                
                DispatchQueue.main.async {
                    self.distance = Int(count ?? 0.0)
                }
                
            }
        }
    }
    
}

