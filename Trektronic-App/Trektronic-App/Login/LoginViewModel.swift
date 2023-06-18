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

    var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    @Published var showScreen = false
    
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
                        showScreen = true
                    }
                    await MainActor.run {
                        userID = userData.uid
                    }
                    let data = try await fireBaseManager.getData(id: userData.uid)
                    if data.registrationDate == nil {
                        try await self.fireBaseManager.setData(nickname: "nickname" ,registrationDate: Date.now, id: userData.uid)
                    }
                }
                
            } catch {
                print (error.localizedDescription)
            }
        }
        
    }
    
}
