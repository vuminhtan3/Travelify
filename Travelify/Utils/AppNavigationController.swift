//
//  AppNavigationController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 29/08/2023.
//

import UIKit

class AppNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarHidden(true, animated: false)
        navigationBar.isHidden = true
    }
}
