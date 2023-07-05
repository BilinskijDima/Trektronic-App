//
//  TabBarViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import Foundation
import SwiftUI
import HealthKit
import Combine

enum Tab: String, CaseIterable {
    
    case house
    case chart = "chart.xyaxis.line"
    case person
    case gearshape
    
    var color: Color {
        switch self {
        case .house:
            return .gray
        case .chart:
            return .gray
        case .person:
            return .gray
        case .gearshape:
            return .gray
        }
    }
}

final class TabBarViewModel: ObservableObject  {
    
    private var cancellable = Set <AnyCancellable>()
    
    @Published var alert: AlertTypes? = nil
    
    @Published var steps: Float = 0
    
    @Published var userSelf: Users?
    
    @Published var statisticsViewModel = StatisticsViewModel()
    
    init() {
        $steps
            .sink { [weak self] step in
                self?.statisticsViewModel.steps = step
            print ("sink \(step)")
        }
        .store(in: &cancellable)
    }
    
    @AppStorage("dataCoin") var dataCoin = DefaultSettings.dataCoin
    
    @AppStorage("userID") var userID = DefaultSettings.userID
    
    private var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    private var healthKitManager: HealthKitManagerProtocol = HealthKitManager()
    
    @Published var selectedTab: Tab = .house
     
    var selectedColor: Color {
        switch selectedTab {
        case .house:
            return Color.red
        case .chart:
            return Color.green
        case .person:
            return Color.purple
        case .gearshape:
            return Color.blue
            
        }
    }
    
    func calculateDataHealthKitStep() {
        
        let date = Calendar.current.startOfDay(for: Date())
        
        guard healthKitManager.healthStore != nil, let steps = HKQuantityType.quantityType(forIdentifier: .stepCount)
        else {return}
        
        healthKitManager.getTodayStepsObserver(withStart: date, dataType: steps) {[weak self] result in
            guard let sum = result?.sumQuantity(), let self = self else {return}
            
            let resultStep = Float(sum.doubleValue(for: HKUnit.count()))
        
            let dateNow = Date.now.dateToString()
   
            if resultStep >= 10000 && dataCoin != dateNow {
                
                let coin = (userSelf?.coin ?? 0) + 1
                
                let dateNowApp = Date.now.dateToString()
                
                dataCoin = dateNowApp
                
                updateData(value: coin, nameValueUpdate: "coin")
                
            }
            
            updateData(value: Int(resultStep), nameValueUpdate: "step")
            
            DispatchQueue.main.async {
                self.steps = resultStep
            }
        }
    }
    
    func updateData(value: Int, nameValueUpdate: String) {
        fireBaseManager.updateData(nameValueUpdate: nameValueUpdate, id: userID, value: value)
    }
    
    func fetchUser() {
        self.fireBaseManager.getDataRealTime(id: userID) {[weak self] dataSnapshot in
            guard let self = self else {return}
            
            do {
                let user = try dataSnapshot.decodeJSON(type: Users.self)
                self.userSelf = user
            } catch {
                self.alert = .defaultButton(title: "Ошибка", message: error.localizedDescription)
            }
            
        }
        
    }
    
    
}
