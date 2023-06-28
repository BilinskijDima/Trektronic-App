//
//  PeopleViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 25.06.23.
//

import Foundation

final class PeopleViewModel: ObservableObject  {
    
    @Published var users = [Users]()

    private var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    func fetchUser() {
        self.fireBaseManager.fetchUser { dataSnapshot in
            do {
                let user = try dataSnapshot.decodeJSON(type: Users.self)
                self.users.append(user)
            } catch {
                print (error.localizedDescription)
            }
        }
    }
    
    
}

