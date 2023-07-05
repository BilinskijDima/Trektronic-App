//
//  LoginViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import Foundation
import CoreData
import SwiftUI

final class LoginViewModel: ObservableObject  {
        
    @AppStorage("userID") var userID = DefaultSettings.userID
    
    @AppStorage("stateLoadingView") var stateLoadView: LoadView = .loginView
    
    @Published var alert: AlertTypes? = nil

    private var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    private var healthKitManager: HealthKitManagerProtocol = HealthKitManager()

    func singInWithGoogle() {
        
        Task {
            do {
                
                let userData = try await self.fireBaseManager.singInWithGoogle()
                
                if userData.isEmailVerified {
                    
                    await MainActor.run {
                        
                        userID = userData.uid
                    }
                    
                    fireBaseManager.getDataRealTime(id: userData.uid, completion: {[weak self] dataSnapshot in
                        guard let self = self else {return}
                        
                        if dataSnapshot.value as? [String: AnyObject] == nil {
                            self.stateLoadView = .onboardingView
                        } else {
                            if healthKitManager.authorizationStatus() {
                                self.stateLoadView = .tabBarView
                            } else {
                                self.stateLoadView = .presettingView
                            }
                        }
                        
                    })
                    
                }
                
            } catch {
                self.alert = .defaultButton(title: "Ошибка", message: error.localizedDescription)
            }
        }
        
    }
    
}

