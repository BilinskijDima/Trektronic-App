//
//  LoginViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import Foundation
import CoreData

final class LoginViewModel: ObservableObject  {
        
    var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
   // это доделаю еще
//    enum SignInState {
//      case signedIn
//      case signedOut
//    }
//
    //    @Published var state: SignInState = .signedOut
    
    @Published var showScreen = false
    
    func singInWithGoogle() {
        
        Task {
            do {
                
                let userData = try await self.fireBaseManager.singInWithGoogle()
                
                if userData.isEmailVerified {
                    
                    await MainActor.run {
                        showScreen = true
                    }
                    
                }
                
            } catch {
                print (error.localizedDescription)
            }
        }
        
    }
    
}
