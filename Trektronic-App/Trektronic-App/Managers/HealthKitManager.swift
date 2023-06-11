//
//  HealthKitManager.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 11.06.23.
//

import Foundation
import HealthKit

protocol HealthKitManagerProtocol {
    
    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void)
    func requestAuthorisation(completion: @escaping (Bool) -> Void)
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
    
    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void) {
    
        let stepType = HKQuantityType.init(HKQuantityTypeIdentifier.stepCount) // это как я понял в будущем замена этому методу
            //.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! // метод deprecated но в офф доке пока нет
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) // с какой даты начинается сбор данных
        
        let anchorDate = Date.mondayAt12AM() //Это значение устанавливает начало дня для каждого из ваших временных интервалов. Технически якорь устанавливает время начала для одного временного интервала. с 00:00 ночи в данном случае
        
        let daily = DateComponents(day: 1) //Интервал данных 1-каждый день 2-каждый второй день и т.д
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        
        query!.initialResultsHandler = { query, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
        
    }
    
    func requestAuthorisation(completion: @escaping (Bool) -> Void) {
        
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        guard let healthStore = self.healthStore else {return completion(false)}
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in
            completion(success)
        }
        
    }
    
}

