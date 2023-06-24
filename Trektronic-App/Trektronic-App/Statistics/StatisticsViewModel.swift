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
    
    private var observerQuery: HKObserverQuery?
    private var query: HKStatisticsQuery?

    
    @AppStorage("stateLoadHealthKit") var stateLoadHealthKit = DefaultSettings.stateLoadHealthKit
    @AppStorage("userID") var userID = DefaultSettings.userID
    
    var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    var healthKitManager: HealthKitManagerProtocol = HealthKitManager()
    
    @Published var stepsWeek: [HealthKitModel] = [HealthKitModel]()
    @Published var steps: Float = 0
    @Published var distance = 0
    @Published var stepAvege = 0
    
    @Published var selectedTab = "Шаги"
    var tabs = ["Шаги", "Дистанция"]
    
    func calculateData() {
        guard healthKitManager.healthStore != nil else {return}
        Task {
            
            guard let data = try await fireBaseManager.getData(id: userID).registrationDate, let dataWeek = Calendar.current.date(byAdding: .day, value: -6, to: Date()) else {return}
            
            if stateLoadHealthKit {
                guard let steps = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
                      let calculateStepsWeek = try await healthKitManager.calculateData(startDate: dataWeek, dataType: steps)
                       
                     // let calculateDistance = try await healthKitManager.calculateData(startDate: data, dataType: distance)
                else {return}
                
                getTodaySteps()
                getMyStepsAvege()
                self.updateUIFromStatistics(calculateStepsWeek)
            }
        }
    }
    
  
    func updateUIFromStatistics(_ statisticsCollectionStepWeek: HKStatisticsCollection) {
        
        guard let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date()) else {return}
        
        Task {
            guard let data = try await fireBaseManager.getData(id: userID).registrationDate else {return}
            
            let endDate = Date()
            
            await MainActor.run {
//                statisticsCollectionStep.enumerateStatistics(from: data, to: endDate) { [weak self] (statistics, stop) in
//
//                    guard let self = self else {return}
//
//                    let count = statistics.sumQuantity()?.doubleValue(for: .count())
//
//                    self.steps = Float(count ?? 0.0)
//
//                }
                
                statisticsCollectionStepWeek.enumerateStatistics(from: startDate, to: endDate) { [weak self] (statistics, stop) in
                    
                    guard let self = self else {return}
                    
                    let count = statistics.sumQuantity()?.doubleValue(for: HKUnit.meter())
                    
                    let stepWeek = HealthKitModel(count: Int(count ?? 0), date: statistics.startDate)
                    
                    self.stepsWeek.append(stepWeek)
                    
                }
                
//                statisticsCollectionDistance.enumerateStatistics(from: data, to: endDate) { [weak self] (statistics, stop) in
//
//                    guard let self = self else {return}
//
//                    let count = statistics.sumQuantity()?.doubleValue(for: HKUnit.meter())
//
//                    self.distance = Int(count ?? 0.0)
//
//                }
                
            }
        }
    }
    
    func getTodaySteps () {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            print ("Error: Identifier .stepCount")
            return
        }
        
        observerQuery = HKObserverQuery(sampleType: stepCountType, predicate: nil, updateHandler: { query, completionHandler, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                
                return
            }
            self.getMySteps()
    
        })
        
        
        observerQuery.map(healthKitManager.healthStore!.execute)
        
    }
            
    
    func getMySteps() {
        
        let stepsQuantityType = HKQuantityType.quantityType (forIdentifier: .stepCount)!
        
        let now = Date ( )
        
        let startOfDay = Calendar.current.startOfDay (for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        self.query = HKStatisticsQuery(quantityType: stepsQuantityType,
                                       quantitySamplePredicate: predicate,
                                       options: .cumulativeSum,
                                       completionHandler: { _ , result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                
                return
            }
            
            DispatchQueue.main.async {
                self.steps = Float(sum.doubleValue(for: HKUnit.count()))
                self.fireBaseManager.setDataRealTime(step: sum.doubleValue(for: HKUnit.count()))
                
            }
        })
        
        query.map(healthKitManager.healthStore!.execute)
    }
        func getMyStepsAvege() {
            
            guard let dataWeek = Calendar.current.date(byAdding: .day, value: -6, to: Date()) else {return}
            
            let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
           // let discreteHeartRate = HKSampleType.quantityType(forIdentifier: .stepCount)!
           
            
            let now = Date ( )
            
            let startOfDay = Calendar.current.startOfDay (for: now)
            
            let predicate = HKQuery.predicateForSamples(withStart: dataWeek, end: now, options: .strictStartDate)
            
            self.query = HKStatisticsQuery(quantityType: stepsQuantityType,
                                           quantitySamplePredicate: predicate,
                                           options: .cumulativeSum,
                                           completionHandler: { _ , result, _ in
                guard let result = result, let sum = result.sumQuantity() else {
             
                    return
                }
                
                DispatchQueue.main.async {
                    self.stepAvege = Int(sum.doubleValue(for: HKUnit.count())) / 7
                 //   self.fireBaseManager.setDataRealTime(step: sum.doubleValue(for: HKUnit.count()))
                   
                }
            })
                    
            query.map(healthKitManager.healthStore!.execute)
        }
    
    
}


