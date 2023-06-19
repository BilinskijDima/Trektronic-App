//
//  HealthKitManager.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 11.06.23.
//

import Foundation
import HealthKit

protocol HealthKitManagerProtocol {
    
  // func calculateSteps(startDate: Date) async throws -> HKStatisticsCollection?
    func calculateData(startDate: Date, dataType: HKQuantityType) async throws -> HKStatisticsCollection?
    func requestAuthorisation() async throws -> Bool
    var healthStore: HKHealthStore? {get}
    
}

class HealthKitManager: HealthKitManagerProtocol {
    
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
//    func calculateSteps(startDate: Date) async throws -> HKStatisticsCollection? {
//        
//        let stepType = HKQuantityType.init(HKQuantityTypeIdentifier.distanceWalkingRunning)
//        
//      // let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
//      //  let startDate = start
//        let anchorDate = Date.mondayAt12AM()
//        
//        let daily = DateComponents(day: 1) // получаем данные поминутно за сутки 1440 записей
//        
//        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
//        
//        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
//        
//        return try await withCheckedThrowingContinuation { continuation in
//            query?.initialResultsHandler = { query, statisticsCollection, error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                } else {
//                    continuation.resume(returning: statisticsCollection)
//                }
//            }
//            
//            if let healthStore = healthStore, let query = self.query {
//                healthStore.execute(query)
//            }
//        }
//    }
    
    func calculateData(startDate: Date, dataType: HKQuantityType) async throws -> HKStatisticsCollection? {
        
      //  let stepType = dataType

      // let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())
      //  let startDate = start
        
        let anchorDate = Date.mondayAt12AM()
        
        let daily = DateComponents(day: 1) // получаем данные поминутно за сутки 1440 записей
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: dataType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        
        return try await withCheckedThrowingContinuation { continuation in
            query?.initialResultsHandler = { query, statisticsCollection, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: statisticsCollection)
                }
            }
            
            if let healthStore = healthStore, let query = self.query {
                healthStore.execute(query)
            }
        }
    }
    
    func requestAuthorisation() async throws -> Bool {
        
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {fatalError("error quantityType HealthKit")}
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {fatalError("error quantityType HealthKit")}
        
        guard let healthStore = self.healthStore else {fatalError("error requestAuthorisation HealthKit")}
        
        return try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(toShare: [stepType, distanceType], read: [stepType, distanceType]) { (success, error) in
                continuation.resume(returning: success)
            }
        }
    }
    
    
}


