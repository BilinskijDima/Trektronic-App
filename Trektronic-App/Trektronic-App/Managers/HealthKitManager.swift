//
//  HealthKitManager.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 11.06.23.
//

import Foundation
import HealthKit

protocol HealthKitManagerProtocol {
    
    func calculateData(startDate: Date, dataType: HKQuantityType) async throws -> HKStatisticsCollection?
    func requestAuthorisation() async throws -> Bool
    var healthStore: HKHealthStore? {get}
    
    func getTodayStepsObserver(withStart: Date, dataType: HKQuantityType, completion: @escaping (HKStatistics?) -> Void)
    
    func getMyStepsObserver(withStart: Date, dataType: HKQuantityType, completion: @escaping (HKStatistics?) -> Void)
    
    func authorizationStatus() -> Bool 
}

class HealthKitManager: HealthKitManagerProtocol {
    
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    
    private var observerQuery: HKObserverQuery?
    private var queryStatistics: HKStatisticsQuery?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func authorizationStatus() -> Bool {
        
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
              let healthStore = healthStore else {fatalError("error quantityType HealthKit")}
    
        return healthStore.authorizationStatus(for: stepType) == .sharingAuthorized && healthStore.authorizationStatus(for: distanceType) == .sharingAuthorized
     
    }
    
    func requestAuthorisation() async throws -> Bool {
        
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
              let healthStore = healthStore else {fatalError("error quantityType HealthKit")}
        
        return try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(toShare: [stepType, distanceType], read: [stepType, distanceType]) { (success, error) in
                continuation.resume(returning: success)
            }
        }
    }
    
    func calculateData(startDate: Date, dataType: HKQuantityType) async throws -> HKStatisticsCollection? {
        
        let anchorDate = Date.mondayAt12AM()
        
        let daily = DateComponents(day: 1)
        
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
    
    
    func getTodayStepsObserver(withStart: Date, dataType: HKQuantityType, completion: @escaping (HKStatistics?) -> Void) {
        
        observerQuery = HKObserverQuery(sampleType: dataType, predicate: nil, updateHandler: { [weak self] query, completionHandler, error in
            guard let self = self else {return}
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        
            self.getMyStepsObserver(withStart: withStart, dataType: dataType) { result in
                completion(result)
            }
            
        })
        if let healthStore = healthStore {
            observerQuery.map(healthStore.execute)
                        
        }
       
    }
    
    
    func getMyStepsObserver(withStart: Date, dataType: HKQuantityType, completion: @escaping (HKStatistics?) -> Void)  {
    
        let predicate = HKQuery.predicateForSamples(withStart: withStart, end:  Date(), options: .strictEndDate)
   
            self.queryStatistics = HKStatisticsQuery(quantityType: dataType,
                                                     quantitySamplePredicate: predicate,
                                                     options: .cumulativeSum,
                                                     completionHandler: { _ , result, _ in
                guard let result = result else { return }
                
                completion(result)
                
            })
            if let healthStore = healthStore {
                queryStatistics.map(healthStore.execute)
            }
        
        
    }
    
  
    
    
 
    
    
}


