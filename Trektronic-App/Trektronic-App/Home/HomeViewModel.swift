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
    
    @Published var stepsCoin: Double = 0.0
    
    @Published var user: Users?
    
    @AppStorage("userID") var userID = DefaultSettings.userID
    
    private var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    private var healthKitManager: HealthKitManagerProtocol = HealthKitManager()
    
    func userData() {
        
        self.fireBaseManager.getDataRealTime(id: userID) {[weak self] dataSnapshot in
            
            guard var json = dataSnapshot.value as? [String: Any], let self = self else {return}
            
            json["id"] = dataSnapshot.key
            
            do {
                let data = try JSONSerialization.data(withJSONObject: json)
                let user = try JSONDecoder().decode(Users.self, from: data)
                print (user)
                self.user = user
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
                
                guard let dateConvert = dateFormatter.date(from: user.date) else {return}
                
                calculateDataHealthKit(withStart: dateConvert)
                
            } catch {
                print (error.localizedDescription)
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
                    self.stepsCoin = round(value * 1000) / 1000.0
                }
            }
        }
    }
}
