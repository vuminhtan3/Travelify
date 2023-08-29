//
//  NoInternetAccessViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 23/08/2023.
//

import UIKit

class NoInternetAccessViewController: UIViewController {

    @IBOutlet weak var retryBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        retryBtn.layer.cornerRadius = retryBtn.frame.height/2
        retryBtn.layer.masksToBounds = true
    }

    @IBAction func retryBtnTapped(_ sender: UIButton) {
        if NetworkMonitor.shared.isReachable {
            let isCompleteOnboarding = UserDefaultsService.shared.completedOnboarding
            let isLoggedIn = UserDefaultsService.shared.isLoggedIn
            let isFirstTimeSetProfile = UserDefaultsService.shared.isFirstTimeSetProfile
            
            //Kiểm tra xem người dùng đã hoàn thành Onboarding Screen và check đăng nhập
            if isCompleteOnboarding {
                if isLoggedIn && isFirstTimeSetProfile {
                    AppDelegate.scene?.routeToSetProfile()
                } else if isLoggedIn {
                    AppDelegate.scene?.routeToMainTabbar()
                } else {
                    AppDelegate.scene?.routeToChooseEntryPoint()
                }
            } else {
                AppDelegate.scene?.routeToOnboarding()
            }
        } else {
            return
        }
        
    }
    
}
