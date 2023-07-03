//
//  PeopleViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 25.06.23.
//

import Foundation
import SwiftUI
import Combine

final class PeopleViewModel: ObservableObject  {

    @Published var users = [Users]()
    
    @Published var userSelf: Users?
    
    @Published var favouritesUser = Set<String>()
    
    @Published var  isShowingInfo = false
    
    @AppStorage("userID") var userID = DefaultSettings.userID
    
    private var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    func fetchAllUsers() {
        self.fireBaseManager.fetchUser { dataSnapshot in
            do {
                let user = try dataSnapshot.decodeJSON(type: Users.self)
                
                if dataSnapshot.key != self.userID {
                    self.users.append(user)
                }
                
            } catch {
                print (error.localizedDescription)
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
        favouritesUser.contains(id)
    }
    
    func fetchUser(id: String) {
        self.fireBaseManager.getDataRealTime(id: id) {[weak self] dataSnapshot in
            guard let self = self else {return}
            
            do {
                let user = try dataSnapshot.decodeJSON(type: Users.self)
                self.userSelf = user
                self.favouritesUser = Set(user.favouritesUser ?? [""])
                
            } catch {
                print (error.localizedDescription)
            }
            
        }
        
    }
    
}


