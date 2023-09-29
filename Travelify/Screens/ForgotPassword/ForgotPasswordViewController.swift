//
//  ForgotPasswordViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 21/07/2023.
//

import UIKit
import Firebase
import FirebaseAuth

enum ForgotPasswordFormField {
    case email
}

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var emailTF: CustomUITextField!
    @IBOutlet weak var emailWarningLb: UILabel!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupView() {
        emailWarningLb.isHidden = true
        
        //Setup Button
        forgotPasswordBtn.layer.cornerRadius = forgotPasswordBtn.frame.height/2
        forgotPasswordBtn.clipsToBounds = true
    }
    
    @IBAction func tappingTFHandle(_ sender: UITextField) {
        emailWarningLb.isHidden = true
    }
    
    @IBAction func forgotBtnTapped(_ sender: UIButton) {
        let email = emailTF.text ?? ""
        let isValid = validateForm(email: email)
        guard isValid else {return}
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.showAlert(title: "Lỗi", message: "Không thể đặt lại mật khẩu cho tài khoản vào lúc này. Xin hãy thử lại sau")
            } else {
                self.showAlert(title: "Thành công", message: "Mật khẩu mới đã được gửi tới email của bạn. Vui lòng kiểm tra email và đăng nhập lại với mật khẩu mới") {
                    AppDelegate.scene?.routeToLogin()
                }
            }
        }
    }
    
    @IBAction func googleLoginBtnTapped(_ sender: UIButton) {
        self.showAlert(title: "Tính năng đang phát triển", message: "Tính năng đang phát triển, xin vui lòng thử lại sau")
    }
    
    @IBAction func facebookLoginBtnTapped(_ sender: UIButton) {
        self.showAlert(title: "Tính năng đang phát triển", message: "Tính năng đang phát triển, xin vui lòng thử lại sau")
    }
    
    
    
}

//MARK: - Validate Form
extension ForgotPasswordViewController {
    private func validateForm(email: String) -> Bool {
        var isValid = true
        
        if email.isEmpty {
            isValid = false
            forgotPasswordValidateFailure(message: "Vui lòng nhập email")
        } else {
            let emailValidator = EmailValidator(email: email)
            let isEmailValid = emailValidator.isValid()
            if !isEmailValid {
                isValid = false
                forgotPasswordValidateFailure(message: "Email sai định dạng")
            }
        }
        return isValid
        
    }
    
    func forgotPasswordValidateFailure(message: String?) {
        emailWarningLb.isHidden = false
        emailWarningLb.text = message
    }
}
