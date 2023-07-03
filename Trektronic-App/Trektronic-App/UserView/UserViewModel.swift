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
    
    @Published var user: Users
    @Published var userSelf: Users?
    @Published var updateUser: (() -> ())
    @Published var isFavorite: (() -> Bool)
    
    @Published var progressUserSelf: CGFloat = 0
    @Published var progressUserFavorit: CGFloat = 0
    
    @Published var userFavorit: Users?
    
    init(user: Users, updateUser: @escaping () -> Void, isFavorite: @escaping () -> Bool) {
        self.user = user
    
        self.updateUser = updateUser
        self.isFavorite = isFavorite
    }
    
    func progressUser() {
        self.progressUserSelf = self.width * (CGFloat(self.userSelf?.step ?? 0)) / (CGFloat(self.userSelf?.step ?? 0) + CGFloat(self.userFavorit?.step ?? 0))
        
        self.progressUserFavorit = self.width * (CGFloat(self.userFavorit?.step ?? 0)) / (CGFloat(self.userSelf?.step ?? 0) + CGFloat(self.userFavorit?.step ?? 0))
    }
      
    func fetchUser() {
        self.fireBaseManager.getDataRealTime(id: user.id) {[weak self] dataSnapshot in
            guard let self = self else {return}
            
            do {
                let user = try dataSnapshot.decodeJSON(type: Users.self)
             
                    self.userFavorit = user
                self.fetchUserSelf()
               
            } catch {
                print (error.localizedDescription)
            }
            
        }
        
    }
    
    func fetchUserSelf() {
        self.fireBaseManager.getDataRealTime(id: userID) {[weak self] dataSnapshot in
            guard let self = self else {return}
            
            do {
                let user = try dataSnapshot.decodeJSON(type: Users.self)
                self.userSelf = user
                self.progressUser()
            } catch {
                print (error.localizedDescription)
            }
            
        }
        
        
    }
    
    
}

