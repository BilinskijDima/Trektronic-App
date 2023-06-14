//
//  LoginViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import Foundation
import CoreData

final class LoginViewModel: ObservableObject  {
    
    private let viewContext = PersistenceController.shared.viewContext
    
    var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    
   // это доделаю еще
//    enum SignInState {
//      case signedIn
//      case signedOut
//    }
//
//    @Published var state: SignInState = .signedOut
    
    @Published var showScreen = false
    
  
    func singInWithGoogle() {
        
        Task {
            do {
             
                let userData = try await self.fireBaseManager.singInWithGoogle()
          
                if userData.isEmailVerified {
                    
                    addDataToCoreData()
                    
                    await MainActor.run {
                        showScreen = true
                       
                    }
                }
                
            } catch {
                print (error.localizedDescription)
            }
        }
        
    }
    
    
    
    
//
//    func saveDataCD(state: Bool) {
//
//            let newItem = UserFB(context: viewContext)
//            newItem.autState = state
//
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//
//    }
    
//    func fetchCompanyData() {
//        let request = NSFetchRequest<UserFB>(entityName: "UserFB")
//
//        do {
//            companyArray = try viewContext.fetch(request)
//        }catch {
//            print("DEBUG: Some error occured while fetching")
//        }
//    }
    
    func addDataToCoreData() {
        let user = UserFB(context: viewContext)
        user.autState = true
        
        do {
            try viewContext.save()
        }catch {
            print("Error saving")
        }
       
    }
    
 
    
    
    
    
    
    
}
