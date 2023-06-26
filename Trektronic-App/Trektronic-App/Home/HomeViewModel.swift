//
//  HomeViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 9.06.23.
//

import Foundation
import HealthKit
import SwiftUI

final class HomeViewModel: ObservableObject  {
    
    @Published var nameUser: String = ""
    @Published var coinUser: Int = 0
    @Published var steps: Double = 0.0
    
    @AppStorage("userID") var userID = DefaultSettings.userID
    
    private var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    private var healthKitManager: HealthKitManagerProtocol = HealthKitManager()
    
    func userData() {
        
        self.fireBaseManager.getDataRealTime(id: userID) {[weak self] DataSnapshot in
            guard let self = self else {return}
            if let dictionary = DataSnapshot.value as? [String: AnyObject] {
                self.nameUser = dictionary["nickname"] as? String ?? "Nickname"  // думаю можно как то более красиво получать дикшинари 
                self.coinUser = dictionary["coin"] as? Int ?? 0
                let dateString = dictionary["date"] as? String ?? "Date"
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
                
                guard let dateConvert = dateFormatter.date(from: dateString) else {return}
                print (dateConvert)
                self.calculateDataHealthKit(withStart: dateConvert)
            }
        }
    }
  
    func calculateDataHealthKit(withStart: Date) {
        
        guard healthKitManager.healthStore != nil, let steps = HKQuantityType.quantityType(forIdentifier: .stepCount) else {return}
        
        if  healthKitManager.authorizationStatus() {
            
            healthKitManager.getTodayStepsObserver(withStart: withStart, dataType: steps) {[weak self] result in
                guard let sum = result?.sumQuantity(), let self = self else {return}
                
                DispatchQueue.main.async {
                    let value = Double(sum.doubleValue(for: HKUnit.count())) / 1000
                    self.steps = round(value * 1000) / 1000.0
                }
            }
        }
    }
}
