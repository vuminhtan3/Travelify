//
//  AppDelegate.swift
//  Travelify
//
//  Created by Minh Tan Vu on 07/07/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import IQKeyboardManagerSwift
import MBProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var shared: AppDelegate?

    var window: UIWindow?
    var listPlaces: [Place] = []

    static let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 100
        IQKeyboardManager.shared.keyboardAppearance = .default
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        NetworkMonitor.shared.startMonitoring()
        
        fetchPlacesData { places in
            self.listPlaces = places
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func fetchPlacesData(completion: @escaping ([Place]) -> Void) {
        
        FirebaseManager.shared.fetchPlacesData { [weak self] places in
            guard let self = self else { return }
            
            self.listPlaces = places
            completion(places)
            print(self.listPlaces)
        }
    }
}

