//
//  HomeViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 9.06.23.
//

import Foundation
import HealthKit

final class HomeViewModel: ObservableObject  {
    
    var healthKitManager: HealthKitManagerProtocol = HealthKitManager()
    
    @Published var steps: [Step] = [Step]()
    
    func calculateData() {
        guard healthKitManager.healthStore != nil else {return}
        Task {
            if try await healthKitManager.requestAuthorisation() {
                guard let calculateSteps = try await healthKitManager.calculateSteps() else {return}
                self.updateUIFromStatistics(calculateSteps)
            }
        }
    }
    
    
    func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        
        guard let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else {return}
        
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            
            DispatchQueue.main.async {
                self.steps.append(step)
            }
            
        }
        
    }
    
}
