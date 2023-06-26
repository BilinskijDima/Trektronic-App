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
            print (dataSnapshot)
            
            guard let dictionary = dataSnapshot.value as? [String: AnyObject] else {return}
                
            print (dictionary)

            guard let date = dictionary["date"] as? String,  let step = dictionary["step"] as? Int,  let coin = dictionary["coin"] as? Int, let nickname = dictionary["nickname"] as? String else {return}
           
            let user = Users(date: date, step: step, coin: coin, nickname: nickname)
            self.users.append(user)
            print (user)

        }
    }
}
