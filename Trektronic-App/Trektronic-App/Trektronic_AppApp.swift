//
//  Trektronic_AppApp.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import SwiftUI
import FirebaseCore

enum DefaultSettings {
    static let stateLoadHomeView = false
    static let stateLoadHealthKit = false
    static let userID = ""
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct Trektronic_AppApp: App {
    
    @AppStorage("stateLoadView") var stateLoadHomeView = DefaultSettings.stateLoadHomeView
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            
            //            let viewContext = CoreDataManager.shared.persistentStoreContainer.viewContext
            //            TestCoreDataView(vm: TestCoreDataViewModel(context: viewContext))
            //                .environment(\.managedObjectContext, viewContext)
            if stateLoadHomeView {
                TabBarView()
            }   else {
                LoginView()
            }
            
        }
    }
    
}
