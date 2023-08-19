//
//  ChooseEntryPointViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 15/08/2023.
//

import UIKit

class ChooseEntryPointViewController: UIViewController {

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerBtn.layer.cornerRadius = registerBtn.frame.height/2
        registerBtn.layer.masksToBounds = true
        loginBtn.layer.cornerRadius = registerBtn.frame.height/2
        loginBtn.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        routeToRegister()
    }
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        routeToLogin()
    }
    
    
    func routeToLogin() {
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func routeToRegister() {
        let registerVC = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        navigationController?.pushViewController(registerVC, animated: true)
    }

}
