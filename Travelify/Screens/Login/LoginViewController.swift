//
//  LoginViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 21/07/2023.
//

import UIKit
import FirebaseAuth

enum LoginFormField {
    case email
    case password
}

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTF: CustomUITextField!
    @IBOutlet weak var passwordTF: CustomUITextField!
    @IBOutlet weak var emailWarningLb: UILabel!
    @IBOutlet weak var passwordWarningLb: UILabel!
    @IBOutlet weak var showPasswordBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var googleLoginBtn: UIButton!
    @IBOutlet weak var facebookLoginBtn: UIButton!
    var showPasswordClick = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        emailTF.text = "123@gmail.com"
        passwordTF.text = "Minhtan97@"
        
        emailWarningLb.isHidden = true
        passwordWarningLb.isHidden = true
        passwordTF.isSecureTextEntry = true
        
        //Setup Button
        loginBtn.layer.cornerRadius = loginBtn.frame.height/4
        loginBtn.clipsToBounds = true
        navigationController?.navigationBar.backItem?.title = ""
        
    }

    @IBAction func tappingTFHandle(_ sender: UITextField) {
        emailWarningLb.isHidden = true
        passwordWarningLb.isHidden = true
        
        let email = emailTF.text ?? ""
        let password = passwordTF.text ?? ""
        loginBtn.isEnabled = false
        let isValid = validateForm(email: email, password: password)
        guard isValid else {return}
        loginBtn.isEnabled = true
        emailWarningLb.isHidden = true
        passwordWarningLb.isHidden = true
    }
    
    @IBAction func showPasswordBtnHandle(_ sender: UIButton) {
        if showPasswordClick {
            passwordTF.isSecureTextEntry = false
            showPasswordBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            passwordTF.isSecureTextEntry = true
            showPasswordBtn.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        showPasswordClick = !showPasswordClick
    }
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        let email = emailTF.text ?? ""
        let password = passwordTF.text ?? ""
        let isValid = validateForm(email: email, password: password)
        guard isValid else {return}
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else {return}
            
            guard error == nil else {
                var message = ""
                
                switch AuthErrorCode.Code(rawValue: error!._code) {
                case .userDisabled:
                    message = "Tài khoản đã bị vô hiệu hoá"
                case .wrongPassword:
                    message = "Sai mật khẩu! Vui lòng thử lại"
                case .userNotFound:
                    message = "Không tìm thấy tài khoản với email đã nhập"
                default:
                    message = error?.localizedDescription ?? "Lỗi không xác định"
                }
                
                let alert = UIAlertController(title: "Ồ!!! Có lỗi", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                return
            }
            self.routeToHome()
        }
        
    }
    
    @IBAction func googleLoginBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func facebookLoginBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        let registerVC = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func forgotPasswordBtnTapped(_ sender: UIButton) {
        let forgotPasswordVC = ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle: nil)
        
        navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    
    func routeToHome() {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        navigationController?.pushViewController(homeVC, animated: true)
    }
}

extension LoginViewController {
    private func validateForm(email: String, password: String) -> Bool {
        var isValid = true
        
        if email.isEmpty {
            isValid = false
            loginValidateFailure(field: .email, message: "Vui lòng nhập email")
        } else {
            let emailValidator = EmailValidator(email: email)
            let isEmailValid = emailValidator.isValid()
            if !isEmailValid {
                isValid = false
                loginValidateFailure(field: .email, message: "Email sai định dạng")
            }
        }
        
        if password.isEmpty {
            isValid = false
            loginValidateFailure(field: .password, message: "Vui lòng nhập mật khẩu")
        } else if password.count < 6 {
            isValid = false
            loginValidateFailure(field: .password, message: "Mật khẩu cần có ít nhất 6 ký tự")
        } else {
            let passwordValidator = PasswordValidator(password: password)
            let isPasswordValid = passwordValidator.isValid()
            if !isPasswordValid {
                isValid = false
                loginValidateFailure(field: .password, message: "Mật khẩu cần bao gồm ký tự in hoa, in thường, và ít nhất 1 số")
            }
        }
        return isValid
        
    }
    
    func loginSuccess() {
        print("Route to main")
    }
    
    func loginValidateFailure(field: LoginFormField, message: String?) {
        switch field {
        case .email:
            emailWarningLb.isHidden = false
            emailWarningLb.text = message
        case .password:
            passwordWarningLb.isHidden = false
            passwordWarningLb.text = message
        }
    }
    
    func loginFailure(errorMsg: String?) {
        let alert = UIAlertController(title: "Login failure", message: errorMsg ?? "Something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
