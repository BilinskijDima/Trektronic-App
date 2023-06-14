//
//  Trektronic_AppApp.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Trektronic_AppApp: App {
 
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \UserFB.autState, ascending: true)], animation: .default)
        
    var itemsUser: FetchedResults<UserFB>
    
    let persistenceController = PersistenceController.shared

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        
        WindowGroup {


            if let state = itemsUser.last?.autState {
                if state {
                    HomeView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }   else {
                    LoginView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }


            }
        }
    }
    
    
}
