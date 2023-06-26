//
//  Trektronic_AppApp.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import SwiftUI
import FirebaseCore

enum DefaultSettings {
    static let userID = ""
}

enum LoadView: String, CaseIterable {
    case loginView
    case tabBarView
    case onboardingView
    case presettingView
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
    
    @AppStorage("stateLoadingView") var stateLoadView: LoadView = .loginView
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
                    
            switch stateLoadView {
            case .loginView:
                LoginView()
            case .tabBarView:
                TabBarView()
            case .onboardingView:
                OnboardingView()
            case .presettingView:
                PresettingView()
            }

        }
    }
    
}
