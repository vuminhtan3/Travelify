//
//  MainTabbarViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 23/08/2023.
//

import UIKit
import ESTabBarController_swift

class MainTabbarViewController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        loadTabBarView()
        selectedIndex = 0
        navigationController?.isNavigationBarHidden = true
    }

    private func setupTabBarAppearance() {
        UITabBar.appearance().backgroundColor = UIColor(hexString: "#FDD777", alpha: 1)
        UITabBar.appearance().tintColor = .clear
    }

    private func loadTabBarView() {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let favoriteVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let searchVC = SearchViewController(nibName: "SearchViewController", bundle: nil)
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        
        let homeTab = setupViewController(viewController: homeVC, title: "", normalImage: "home", selectedImage: "home.fill")
        let favoriteTab = setupViewController(viewController: favoriteVC, title: "", normalImage: "heart", selectedImage: "heart.fill")
        let searchTab = setupViewController(viewController: searchVC, title: "", normalImage: "search", selectedImage: "search")
        let profileTab = setupViewController(viewController: profileVC, title: "", normalImage: "user", selectedImage: "user.fill")
        
        setViewControllers([homeTab, searchTab, profileTab], animated: true)
    }

    private func setupViewController(viewController: UIViewController, title: String, normalImage: String, selectedImage: String) -> UIViewController {
        let viewController = viewController
        let normalImage = UIImage(named: normalImage)
        let selectedImage = UIImage(named: selectedImage)
        let normalTabBarItem = ESTabBarItem(CustomStyleTabBarContentView(), image: normalImage, selectedImage: nil)
        let selectedTabBarItem = ESTabBarItem(CustomStyleTabBarContentView(), image: selectedImage, selectedImage: nil)
        viewController.tabBarItem = normalTabBarItem
        
//         Khi tab được chọn, ta sẽ đặt lại tabBarItem để sử dụng ảnh được chọn
        viewController.tabBarItem = selectedTabBarItem
        
        let nav = UINavigationController(rootViewController: viewController)
        return nav
    }
}
