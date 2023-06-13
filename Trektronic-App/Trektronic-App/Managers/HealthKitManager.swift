//
//  HealthKitManager.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 11.06.23.
//

import Foundation
import HealthKit

protocol HealthKitManagerProtocol {
    
    func calculateSteps() async throws -> HKStatisticsCollection?
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
    
    func calculateSteps() async throws -> HKStatisticsCollection? {
        
        let stepType = HKQuantityType.init(HKQuantityTypeIdentifier.stepCount)
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
        let anchorDate = Date.mondayAt12AM()
        
        let daily = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        
        return try await withUnsafeThrowingContinuation { continuation in
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
        
        guard let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {return false}
        
        guard let healthStore = self.healthStore else {return false}
        
        return await withUnsafeContinuation { continuation in
            healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in
                continuation.resume(returning: success)
            }
        }
    }
    
    
}


