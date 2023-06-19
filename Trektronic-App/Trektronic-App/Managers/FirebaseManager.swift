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
import GoogleSignIn

protocol FirebaseManagerProtocol {
    
    func singInWithGoogle() async throws -> User
    func setData(nickname: String, registrationDate: Date, id: String) async throws
    func getData(id: String) async throws -> UserData
    
}

class FirebaseManager: FirebaseManagerProtocol {
    
    let db = Firestore.firestore()
    
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
    
    func setData(nickname: String, registrationDate: Date, id: String) async throws {
        
        let user = UserData(nickname: nickname, registrationDate: registrationDate)
        
        do {
            try db.collection("userData").document(id).setData(from: user)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    func getData(id: String) async throws -> UserData {
        
        let docRef = db.collection("userData").document(id)
        
        let result = try await docRef.getDocument(as: UserData.self)
        
        return result
    }
    
    
    
    
}
