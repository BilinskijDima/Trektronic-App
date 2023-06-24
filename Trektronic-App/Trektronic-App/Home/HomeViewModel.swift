//
//  HomeViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 9.06.23.
//

import Foundation

final class HomeViewModel: ObservableObject  {
    
    @Published var text: String = "No"

    var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    func ff() {
        
        self.fireBaseManager.getDataRealTime { DataSnapshot in
            self.text = DataSnapshot.description
        }
        
        
    }
  
    

}
