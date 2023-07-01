//
//  UserViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 1.07.23.
//

import Foundation

final class UserViewModel: ObservableObject  {
    
    private var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    @Published var userFavorit: Users?
    
    func fetchUser(id: String) {
        self.fireBaseManager.getDataRealTime(id: id) {[weak self] dataSnapshot in
            guard let self = self else {return}
            
            do {
                let user = try dataSnapshot.decodeJSON(type: Users.self)
             
                    self.userFavorit = user
                
            } catch {
                print (error.localizedDescription)
            }
            
        }
        
    }
    
    
    
    
    
}

