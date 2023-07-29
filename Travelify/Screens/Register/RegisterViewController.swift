//
//  RegisterViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 07/07/2023.
//

import UIKit
import FirebaseAuth

enum RegisterFormField {
    case email
    case password
    case confirmPassword
}

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTF: CustomUITextField!
    @IBOutlet weak var emailWarningLb: UILabel!
    @IBOutlet weak var passwordTF: CustomUITextField!
    @IBOutlet weak var passwordWarningLb: UILabel!
    @IBOutlet weak var confirmPasswordTF: CustomUITextField!
    @IBOutlet weak var confirmPasswordWarningLb: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var googleLoginBtn: UIButton!
    @IBOutlet weak var facebookLoginBtn: UIButton!
    @IBOutlet weak var showPasswordBtn: UIButton!
    @IBOutlet weak var showConfirmPasswordBtn: UIButton!
    var showPasswordClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        emailWarningLb.isHidden = true
        passwordWarningLb.isHidden = true
        confirmPasswordWarningLb.isHidden = true
        passwordTF.isSecureTextEntry = true
        confirmPasswordTF.isSecureTextEntry = true
        
        //Setup Button
        
        registerBtn.layer.cornerRadius = registerBtn.frame.height/4
        registerBtn.layer.masksToBounds = true
        
    }
    
    @IBAction func tappingTFHandle(_ sender: CustomUITextField) {
        emailWarningLb.isHidden = true
        passwordWarningLb.isHidden = true
        confirmPasswordWarningLb.isHidden = true
    }
    
    @IBAction func showPasswordBtnHandle(_ sender: UIButton) {
        if showPasswordClick {
            passwordTF.isSecureTextEntry = false
            confirmPasswordTF.isSecureTextEntry = false
            showPasswordBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            showConfirmPasswordBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)

        } else {
            passwordTF.isSecureTextEntry = true
            confirmPasswordTF.isSecureTextEntry = true
            showPasswordBtn.setImage(UIImage(systemName: "eye"), for: .normal)
            showConfirmPasswordBtn.setImage(UIImage(systemName: "eye"), for: .normal)

        }
        showPasswordClick = !showPasswordClick
    }
    
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        let email = emailTF.text ?? ""
        let password = passwordTF.text ?? ""
        let confirmPassword = confirmPasswordTF.text ?? ""
        
        let isValid = validateForm(email: email, password: password, confirmPassword: confirmPassword)
        guard isValid else {return}
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else {return}
            
            if let error = error {
                //Show alert to user when register has an error
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            } else {
                //What is going to do when register successfull
                print("Register successfull -> Route to main")
            }
        }
        
    }
    
    @IBAction func googleLoginBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func facebookLoginBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        routeToLogin()
    }
    
    
    func routeToLogin() {
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
}

//MARK: - Validate Form
extension RegisterViewController {
    private func validateForm(email: String, password: String, confirmPassword: String) -> Bool {
        var isValid = true
        
        if email.isEmpty {
            isValid = false
            registerValidateFailure(field: .email, message: "Vui lòng nhập email")
        } else {
            let emailValidator = EmailValidator(email: email)
            let isEmailValid = emailValidator.isValid()
            if !isEmailValid {
                isValid = false
                registerValidateFailure(field: .email, message: "Email sai định dạng")
            }
        }
        
        if password.isEmpty {
            isValid = false
            registerValidateFailure(field: .password, message: "Vui lòng nhập mật khẩu")
        } else if password.count < 6 {
            isValid = false
            registerValidateFailure(field: .password, message: "Mật khẩu cần có ít nhất 6 ký tự")
        } else {
            let passwordValidator = PasswordValidator(password: password)
            let isPasswordValid = passwordValidator.isValid()
            if !isPasswordValid {
                isValid = false
                registerValidateFailure(field: .password, message: "Mật khẩu cần bao gồm ký tự in hoa, in thường, và ít nhất 1 số")
            }
        }
        
        if confirmPassword.isEmpty {
            isValid = false
            registerValidateFailure(field: .confirmPassword, message: "Vui lòng xác nhận mật khẩu")
        } else if confirmPassword != password {
            isValid = false
            registerValidateFailure(field: .confirmPassword, message: "Mật khẩu không trùng khớp")
        }
        
        return isValid
        
    }
    
    func registerSuccess() {
        print("Route to main")
    }
    
    func registerValidateFailure(field: RegisterFormField, message: String?) {
        switch field {
        case .email:
            emailWarningLb.isHidden = false
            emailWarningLb.text = message
        case .password:
            passwordWarningLb.isHidden = false
            passwordWarningLb.text = message
        case .confirmPassword:
            confirmPasswordWarningLb.isHidden = false
            confirmPasswordWarningLb.text = message
        }
    }
    
    func registerFailure(errorMsg: String?) {
        let alert = UIAlertController(title: "Login failure", message: errorMsg ?? "Something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
