//
//  SettingsViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 25.06.23.
//

import Foundation

final class SettingsViewModel: ObservableObject  {
    
    private var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    
    func singOut() {
        fireBaseManager.singOutWithGoogle()
    }
    
    
}
