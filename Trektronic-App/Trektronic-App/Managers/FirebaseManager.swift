//
//  FirebaseManager.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift
import FirebaseDatabase
import FirebaseDatabaseSwift
import GoogleSignIn
import SwiftUI

protocol FirebaseManagerProtocol {
    
    func singInWithGoogle() async throws -> User
    func setDataRealTime(nickname: String, step: Int, date: String, coin: Int, id: String) async throws
    func getDataRealTime(id: String, completion: @escaping (DataSnapshot) -> Void)
    func checkUserNameAlreadyExist(newUserName: String, completion: @escaping(Bool) -> Void)
    func fetchUser(completion: @escaping(DataSnapshot) -> Void)
    func singOutWithGoogle()
}

class FirebaseManager: FirebaseManagerProtocol {
    
    @AppStorage("stateLoadingView") var stateLoadView: LoadView = .loginView
    
    let db = Firestore.firestore()
    let ref = Database.database().reference()
    
    func singInWithGoogle() async throws -> User {
        guard let clientID = FirebaseApp.app()?.options.clientID else { fatalError("error") }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene =  await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window =  await windowScene.windows.first,
              let rootViewController =  await window.rootViewController else { fatalError("error") }
        
        do {
            let signIn = try await  GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = signIn.user
            guard let idToken = user.idToken else { fatalError("error") }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: user.accessToken.tokenString)
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            return firebaseUser
        } catch {
            print(error.localizedDescription)
            throw error
        }
        
    }
    
    func singOutWithGoogle() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.stateLoadView = .loginView
        } catch  {
            print("Error signing out: ", error)
        }
    }

    func setDataRealTime(nickname: String, step: Int, date: String, coin: Int, id: String) async throws {
        let userReference = ref.child("users").child(id)
        let value = ["nickname":nickname, "step":step, "date":date, "coin": coin] as [String : Any]
        do {
            try await userReference.updateChildValues(value)
            print ("Saved user successfully")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func getDataRealTime(id: String, completion: @escaping(DataSnapshot) -> Void) {
        ref.child("users").child(id).observe(.value) { snapshot in
            completion(snapshot)
        }
    }
    
    func fetchUser(completion: @escaping(DataSnapshot) -> Void) {
        ref.child("users").observe(.childAdded) { snapshot in
            completion(snapshot)
        }
    }
    
    func checkUserNameAlreadyExist(newUserName: String, completion: @escaping(Bool) -> Void) {
        ref.child("users").queryOrdered(byChild: "nickname").queryEqual(toValue: newUserName)
                  .observeSingleEvent(of: .value, with: { snapshot in

            if snapshot.exists() {
                completion(true)
            }
            else {
                completion(false)
            }
        })
    }
    
    
    
}
