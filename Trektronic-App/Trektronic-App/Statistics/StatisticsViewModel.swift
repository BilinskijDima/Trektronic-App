//
//  StatisticsViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 18.06.23.
//

import Foundation
import HealthKit
import SwiftUI

enum ChartsState: String, CaseIterable {
    case steps = "Шаги"
    case distance = "Дистанция"
}

final class StatisticsViewModel: ObservableObject  {
    
    @AppStorage("userID") var userID = DefaultSettings.userID
    
    private var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    private var healthKitManager: HealthKitManagerProtocol = HealthKitManager()
    
    @Published var stepsWeek: [HealthKitModel] = [HealthKitModel]()
    @Published var distanceWeek: [HealthKitModel] = [HealthKitModel]()
    @Published var steps: Float = 0
    @Published var distance = 0
    @Published var stepAvenge = 0
    @Published var distanceAvenge = 0
   
    @Published var selectedTab: ChartsState = .steps
    
    func calculateDataHealthKit() {
        
        guard healthKitManager.healthStore != nil, let dateWeek = Calendar.current.date(byAdding: .day, value: -6, to: Date()), let steps = HKQuantityType.quantityType(forIdentifier: .stepCount),  let distance = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {return}
        
        let date = Calendar.current.startOfDay(for: Date())
        
        if  healthKitManager.authorizationStatus() {
            
            Task {
                guard let calculateStepsWeek = try await healthKitManager.calculateData(startDate: dateWeek, dataType: steps), let calculateDistanceWeek = try await healthKitManager.calculateData(startDate: dateWeek, dataType: distance) else {return}
                self.weekStatisticsSteps(calculateStepsWeek, calculateDistanceWeek)
            }
            
            healthKitManager.getTodayStepsObserver(withStart: dateWeek, dataType: steps) {[weak self] result in
                guard let sum = result?.sumQuantity(), let self = self else {return}
                
                DispatchQueue.main.async {
                    self.stepAvenge = Int(sum.doubleValue(for: HKUnit.count())) / 7
                }
                
            }
            
            healthKitManager.getTodayStepsObserver(withStart: date, dataType: steps) {[weak self] result in
                guard let sum = result?.sumQuantity(), let self = self else {return}
                
                DispatchQueue.main.async {
                    self.steps = Float(sum.doubleValue(for: HKUnit.count()))
                    print (Float(sum.doubleValue(for: HKUnit.count())))
                }
            }
            
            healthKitManager.getTodayStepsObserver(withStart: dateWeek, dataType: distance) {[weak self] result in
                guard let sum = result?.sumQuantity(), let self = self else {return}
                
                DispatchQueue.main.async {
                    self.distanceAvenge = Int(sum.doubleValue(for: HKUnit.meter())) / 7
                }
                
            }
            
            healthKitManager.getTodayStepsObserver(withStart: date, dataType: distance) {[weak self] result in
                guard let sum = result?.sumQuantity(), let self = self else {return}
                
                DispatchQueue.main.async {
                    self.distance = Int(sum.doubleValue(for: HKUnit.meter()))
                }
                
            }
            
        }
    }
    
    
    func weekStatisticsSteps(_ statisticsCollectionStepWeek: HKStatisticsCollection, _ statisticsCollectionDistanceWeek: HKStatisticsCollection) {
        
        guard let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date()) else {return}
        
        Task {
            
            let endDate = Date()
            
            await MainActor.run {
                
                statisticsCollectionStepWeek.enumerateStatistics(from: startDate, to: endDate) { [weak self] (statistics, stop) in
                    
                    guard let self = self else {return}
                    
                    let count = statistics.sumQuantity()?.doubleValue(for: HKUnit.count())
                    
                    let stepWeek = HealthKitModel(count: count ?? 0.0, date: statistics.startDate)
                    
                    self.stepsWeek.append(stepWeek)
                }
                
                statisticsCollectionDistanceWeek.enumerateStatistics(from: startDate, to: endDate) { [weak self] (statistics, stop) in
                    
                    guard let self = self else {return}
                    
                    guard let count = statistics.sumQuantity()?.doubleValue(for: HKUnit.meter()) else {return}
                    let kil = count 
                    let stepWeek = HealthKitModel(count: kil, date: statistics.startDate)
                    
                    self.distanceWeek.append(stepWeek)
                    
                }
            
            }
        }
        
        
    }
    
    
}
    
