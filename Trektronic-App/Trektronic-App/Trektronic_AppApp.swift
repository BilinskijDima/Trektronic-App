//
//  Trektronic_AppApp.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import SwiftUI
import FirebaseCore

enum CustomError: Error {
    
    case failedLoadingHK
    
    case failedLoadingDataHK
    
    var description: String {
        switch self {
        case .failedLoadingHK:
            return "Извините у нас нет доступа к хранилищу HealthKit, зайдите в настройки и разрешите доступ"
        case .failedLoadingDataHK:
            return "Не получилось получить доступ к данным"
        }
    }
}

enum AlertTypes: Identifiable {
    
    case defaultButton(title: String,
                       message: String)
    
    case twoButton(title: String,
                   message: String,
                   primaryButton: Alert.Button,
                   secondaryButton: Alert.Button)
    
    var alert: Alert {
        switch self {
        case .defaultButton(title: let title,
                            message: let message):
            
            return Alert(title: Text(title),
                         message: Text(message))
            
        case .twoButton(title: let title,
                        message: let message,
                        primaryButton: let primaryButton,
                        secondaryButton: let secondaryButton):
            
            return Alert(title: Text(title),
                         message: Text(message),
                         primaryButton: primaryButton,
                         secondaryButton: secondaryButton)
        }
    }
    
    var id: String {
        switch self {
        case .defaultButton:
            return "ok"
        case .twoButton:
            return "twoButton"
        }
    }
}

enum DefaultSettings {
    static let userID = ""
    static let dataCoin = ""
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
