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
    
    @Published var alert: AlertTypes? = nil
    
    @Published var steps: Float = 0
    
    @AppStorage("userID") var userID = DefaultSettings.userID
    
    private var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    private var healthKitManager: HealthKitManagerProtocol = HealthKitManager()
    
    @Published var stepsWeek: [HealthKitModel] = [HealthKitModel]()
    @Published var distanceWeek: [HealthKitModel] = [HealthKitModel]()
    @Published var currentActiveItem: HealthKitModel?
    
    var dataChart: [HealthKitModel] {
        switch selectedTab {
        case .steps:
            return stepsWeek
        case .distance:
            return distanceWeek
        }
    }
    
    var mapDataChart: [Date] {
        self.dataChart.map { $0.date }
    }
    
    @Published var distance = 0
    @Published var stepAvenge = 0
    @Published var distanceAvenge = 0
    
    @Published var setCoin = 0
    
    @Published var selectedTab: ChartsState = .steps
    
    @Published var sumStepWeek = [Double]()
    @Published var sumStepWeekResult = false
    
    @Published var isShowingInfo = false
    
    func calculateDataHealthKit() {
        guard healthKitManager.healthStore != nil,
              let dateWeek = Calendar.current.date(byAdding: .day, value: -6, to: Date()),
              let steps = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let distance = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            self.alert = .defaultButton(title: "Ошибка", message: CustomError.failedLoadingDataHK.description)
            return }
        
        let date = Calendar.current.startOfDay(for: Date())
        
        if  healthKitManager.authorizationStatus() {
            
            Task {
                do {
                    guard let calculateStepsWeek = try await healthKitManager.calculateData(startDate: dateWeek, dataType: steps),
                          let calculateDistanceWeek = try await healthKitManager.calculateData(startDate: dateWeek, dataType: distance) else {return}
                    
                    self.weekStatisticsSteps(calculateStepsWeek, calculateDistanceWeek)
                } catch {
                    self.alert = .defaultButton(title: "Ошибка", message: error.localizedDescription)
                }
            }
            
            healthKitManager.getTodayStepsObserver(withStart: dateWeek, dataType: steps) {[weak self] result in
                guard let sum = result?.sumQuantity(), let self = self else { return }
                
                DispatchQueue.main.async {
                    self.stepAvenge = Int(sum.doubleValue(for: HKUnit.count())) / 7
                }
                
            }
            
            healthKitManager.getTodayStepsObserver(withStart: dateWeek, dataType: distance) {[weak self] result in
                guard let sum = result?.sumQuantity(), let self = self else { return }
                
                DispatchQueue.main.async {
                    self.distanceAvenge = Int(sum.doubleValue(for: HKUnit.meter())) / 7
                }
                
            }
            
            healthKitManager.getTodayStepsObserver(withStart: date, dataType: distance) {[weak self] result in
                guard let sum = result?.sumQuantity(), let self = self else { return }
                
                DispatchQueue.main.async {
                    self.distance = Int(sum.doubleValue(for: HKUnit.meter()))
                }
            }
        } else {
            alert = .twoButton(title: "Ошибка", message: CustomError.failedLoadingHK.description, primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Настройки"), action: {
                if let url = URL.init(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
        }
    }
    
    
    func updateSteps(value: Int) {
        fireBaseManager.updateData(nameValueUpdate: "step", id: userID, value: value)
    }
    
    func weekStatisticsSteps(_ statisticsCollectionStepWeek: HKStatisticsCollection, _ statisticsCollectionDistanceWeek: HKStatisticsCollection) {
        guard let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date()) else {return}
                    
        DispatchQueue.main.async {
            
            self.stepsWeek.removeAll()
            self.sumStepWeek.removeAll()
            self.distanceWeek.removeAll()
    
            statisticsCollectionStepWeek.enumerateStatistics(from: startDate, to:  Date()) { [weak self] (statistics, stop) in
                
                guard let self = self else {return}
                
                let count = statistics.sumQuantity()?.doubleValue(for: HKUnit.count())
                
                self.sumStepWeek.append(count ?? 0.0)
                
                let stepWeek = HealthKitModel(count: count ?? 0.0, date: statistics.startDate)
                
                self.stepsWeek.append(stepWeek)
            }
            
            statisticsCollectionDistanceWeek.enumerateStatistics(from: startDate, to:  Date()) { [weak self] (statistics, stop) in
                
                guard let self = self else {return}
                
                let count = statistics.sumQuantity()?.doubleValue(for: HKUnit.meter())
                
                let stepWeek = HealthKitModel(count: count ?? 0, date: statistics.startDate)
                
                self.distanceWeek.append(stepWeek)
                
            }
            self.statusSumStepWeek()
        }
    }
    
    func statusSumStepWeek() {
        
        let sumStepWeek = sumStepWeek.reduce(0.0, { $0 + $1 })
        
        DispatchQueue.main.async {
            self.sumStepWeekResult = sumStepWeek == 0.0
        }
    }
    
}
    
