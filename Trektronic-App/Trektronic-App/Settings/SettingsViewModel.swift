//
//  SettingsViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 25.06.23.
//

import Foundation
import SwiftUI

final class SettingsViewModel: ObservableObject  {
    
    private var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    @AppStorage("userID") var userID = DefaultSettings.userID

    @Published var showImagePicker = false
    @Published var errorText = ""
    @Published var user: Users?
    
    @Published var textFieldName = ""
    
    @Published var image: UIImage?
    
    @Published var isShowingInfo = false
    
    func singOut() {
        fireBaseManager.singOutWithGoogle()
    }
    
    
    func fetchDataUser() {
        fireBaseManager.getDataRealTime(id: userID, completion: { [weak self] dataSnapshot in
            guard let self = self else {return}
            
            do {
                let user = try dataSnapshot.decodeJSON(type: Users.self)
                
                self.user = user
                
            } catch {
                print (error.localizedDescription)
            }
        })
        
    }
    
    func updateData(value: Any, nameValueUpdate: String) {
        fireBaseManager.updateData(nameValueUpdate: nameValueUpdate, id: userID, value: value)
    }
   
    func checkNickname() {
        guard !self.textFieldName.isEmpty else {
            self.errorText = "вы не ввели имя"
            return}
        
        fireBaseManager.checkUserNameAlreadyExist(newUserName: self.textFieldName) { [weak self] result in
            guard let self = self else {return}
            if result {
                self.errorText = "извините это имя уже занято"
            } else {
                updateData(value: self.textFieldName, nameValueUpdate:  "nickname")
                self.errorText = ""
            }
        }
    }
    
    func saveImage() {
        Task {
            guard let newImage = image else {return}
            
            let imageURL = try await fireBaseManager.persistImageToStorage(userID: userID, image: newImage)
            
            self.updateData(value: imageURL, nameValueUpdate: "image")
        }
    }
    
}

