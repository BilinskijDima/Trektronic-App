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

    private var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    @Published var showScreen = false
    @Published var showScreen2 = false
    
   // это доделаю еще
//    enum SignInState {
//      case signedIn
//      case signedOut
//    }
//
    //    @Published var state: SignInState = .signedOut
    
    func singInWithGoogle() {
        
        Task {
            do {
                
                let userData = try await self.fireBaseManager.singInWithGoogle()
                
                if userData.isEmailVerified {
                    
                    await MainActor.run {
                        
                        userID = userData.uid
                    }
                    
                    fireBaseManager.getDataRealTime(id: userData.uid, completion: {[weak self] DataSnapshot in
                        guard let self = self else {return}
                        if let _ = DataSnapshot.value as? [String: AnyObject] {
                            self.stateLoadView = .presettingView
                        } else {
                            self.stateLoadView = .onboardingView
                        }
                        
                    })
                    
                }
                
            } catch {
                print (error.localizedDescription)
            }
        }
        
    }
    
}

