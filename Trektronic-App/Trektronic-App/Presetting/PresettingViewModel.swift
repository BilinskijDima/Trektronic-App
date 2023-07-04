//
//  PresettingViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 24.06.23.
//

import Foundation
import SwiftUI

final class PresettingViewModel: ObservableObject  {
    
    private var healthKitManager: HealthKitManagerProtocol = HealthKitManager()
    private var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
    @AppStorage("stateLoadingView") var stateLoadView: LoadView = .loginView
    @AppStorage("userID") var userID = DefaultSettings.userID
    
    @Published var alert: AlertTypes? = nil
    
    @Published var showImagePicker = false
    @Published var image: UIImage?
    @Published var imageURL: String?
    
    @Published var textFieldName = ""
    @Published var disableTextFieldName = false
    @Published var stateNickname = false
    
    @Published var stateHealthKit = false
    
    @Published var errorText = ""
    @Published var setData = false
    
    @Published var activateIndicator = false
    
    @MainActor
    func requestAuthorisation() {
        Task {
            do {
                stateHealthKit = try await healthKitManager.requestAuthorisation()
            } catch {
                self.alert = .defaultButton(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    func authorizationStatusHK() {
        stateHealthKit = healthKitManager.authorizationStatus()
    }
    
    func stateSaveData() {
        if self.setData {
            self.setDataRealTime()
        } else {
            self.stateLoadView = .tabBarView
        }
    }
    
    func checkNickname() {
        guard !self.textFieldName.isEmpty else {
            self.errorText = "вы не ввели имя"
            self.stateNickname = false
            return}
        
        fireBaseManager.checkUserNameAlreadyExist(newUserName: self.textFieldName) { [weak self] result in
            guard let self = self else {return}
            if result {
                self.errorText = "извините это имя уже занято"
                self.stateNickname = false
            } else {
                self.stateNickname = true
                self.errorText = ""
            }
        }
    }
    
    func setDataRealTime() {
        Task {
            do {
                guard let defaultImage = UIImage(named: "DefaultAvatar") else {return}
                
                let imageURL = try await fireBaseManager.persistImageToStorage(userID: userID, image: image ?? defaultImage)
                
                let user = Users(date: Date.now.description, step: 0, coin: 0, nickname: textFieldName, image: imageURL, favouritesUser: [""], id: userID)
                
                try await fireBaseManager.setDataRealTime(user: user, id: userID)
                
                await MainActor.run {
                    self.stateLoadView = .tabBarView
                }
            } catch {
                self.alert = .defaultButton(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }

    func stateAutUser() {
        self.fireBaseManager.getDataRealTime(id: userID) {[weak self] dataSnapshot in
            guard let self = self else {return}
           
            if "\(dataSnapshot.value!)" == "<null>" {
                print ("пользователь нет")
                self.setData = true
            } else {
                do {
                    let user = try dataSnapshot.decodeJSON(type: Users.self)
                    print ("пользователь есть")
                    self.imageURL = user.image
                    self.textFieldName = user.nickname
                    self.disableTextFieldName = true
                    self.stateNickname = true
                } catch {
                    self.alert = .defaultButton(title: "Ошибка", message: error.localizedDescription)
                }
            }

        }
        
    }
    
}

