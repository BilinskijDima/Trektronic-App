//
//  UserViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 1.07.23.
//

import Foundation
import SwiftUI

final class UserViewModel: ObservableObject  {
    
    @AppStorage("userID") var userID = DefaultSettings.userID
    
    private var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    let width: CGFloat = 300
    let height: CGFloat = 35
    
    
    @Published var progressUserSelf: CGFloat = 0
    @Published var progressUserFavorit: CGFloat = 0
    @Published var userFavoritData: Users?
    
    
    func progressUser(userSelf: CGFloat, userFavorit: CGFloat) {
        self.progressUserSelf = self.width * (userSelf) / (userSelf + userFavorit)
        
        self.progressUserFavorit = self.width * (userFavorit) / (userSelf + userFavorit)
    }
      
    func fetchUser(id: String, userSelfStep: Int) {
        self.fireBaseManager.getDataRealTime(id: id) {[weak self] dataSnapshot in
            guard let self = self else {return}
            
            do {
                let user = try dataSnapshot.decodeJSON(type: Users.self)
             
                    self.userFavoritData = user

           
                self.progressUser(userSelf: CGFloat(userSelfStep), userFavorit: CGFloat(user.step))
                
            } catch {
                print (error.localizedDescription)
            }
            
        }
        
    }
    
    
}

