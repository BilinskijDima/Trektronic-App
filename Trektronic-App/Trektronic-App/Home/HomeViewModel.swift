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
    
    @Published var favouritesUser = Set<String>()
    
    @Published var stepsCoin: Double = 0.0
    
    @Published var users = [Users]()
    
    @Published var user: Users?
    
    @Published var favouritesUserCheck = false
    
    @Published var isShowingInfo = false
   
    
    @AppStorage("userID") var userID = DefaultSettings.userID
    
    private var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    private var healthKitManager: HealthKitManagerProtocol = HealthKitManager()
    
    func userData() {
        
        self.fireBaseManager.getDataRealTime(id: userID) {[weak self] dataSnapshot in
            guard let self = self else {return}
            
            do {
                let user = try dataSnapshot.decodeJSON(type: Users.self)
                
                self.user = user
                self.favouritesUser = Set(user.favouritesUser ?? [""])
                guard let date = user.date.stringToDate() else {return}
 
                calculateDataHealthKit(withStart: date)
            } catch {
                print (error.localizedDescription)
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
    
    func updateFavorite(id: String) {
        if favouritesUser.contains(id) {
            favouritesUser.remove(id)
            let array = Array(favouritesUser)
            print (array)
            fireBaseManager.updateData(nameValueUpdate: "favouritesUser", id: userID, value: array)
            
        } else {
            favouritesUser.insert(id)
            let array = Array(favouritesUser)
            print (array)
            fireBaseManager.updateData(nameValueUpdate: "favouritesUser", id: userID, value: array)
            
        }
    }
    
    func isFavorite(id: String) -> Bool {
        Set(user?.favouritesUser ?? [""]).contains(id)
    }
    
    func fetchFavoriteUser() {
        self.fireBaseManager.fetchUser { dataSnapshot in
            do {
                let userFavorite = try dataSnapshot.decodeJSON(type: Users.self)
                guard let favouritesUser = self.user?.favouritesUser else {return}
                
                
                if self.favouritesUser.map({$0}).contains(userFavorite.id) {
                    self.users.append(userFavorite)
                }

                self.favouritesUserCheck = favouritesUser.count == 1
         
                
            } catch {
                print (error.localizedDescription)
            }
        }
    }
    
}
