//
//  SceneDelegate.swift
//  Travelify
//
//  Created by Minh Tan Vu on 07/07/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
        
        let isCompleteOnboarding = UserDefaultsService.shared.completedOnboarding
        let isLoggedIn = UserDefaultsService.shared.isLoggedIn
        let isFirstTimeSetProfile = UserDefaultsService.shared.isFirstTimeSetProfile
        
        //Kiểm tra xem người dùng đã hoàn thành Onboarding Screen và check đăng nhập
        if isCompleteOnboarding {
            if isLoggedIn && isFirstTimeSetProfile {
                
                //App bị crash ko rõ nguyên nhân khi chưa setup profile mà thoát app
                routeToSetProfile()
            } else if isLoggedIn {
                routeToHome()
            } else {
                routeToChooseEntryPoint()
            }
        } else {
            routeToOnboarding()
        }
        
    }
    
    
    func routeToLogin() {
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func routeToRegister() {
        let registerVC = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: registerVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func routeToOnboarding() {
        let onboardingVC = OnboardingViewController(nibName: "OnboardingViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: onboardingVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func routeToChooseEntryPoint() {
        let chooseEntryPointVC = ChooseEntryPointViewController(nibName: "ChooseEntryPointViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: chooseEntryPointVC)
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else {return}
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
    
    func routeToHome() {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: homeVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func routeToSetProfile() {
        let setProfile = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: setProfile)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

