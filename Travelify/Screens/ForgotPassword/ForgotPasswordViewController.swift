//
//  ForgotPasswordViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 21/07/2023.
//

import UIKit

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
        
        print("Submit forgot password require successfull -> ")
        
    }
    
    @IBAction func googleLoginBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func facebookLoginBtnTapped(_ sender: UIButton) {
        
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
    
    func submitSuccess() {
        print("Route to main")
    }
    
    func forgotPasswordValidateFailure(message: String?) {
        emailWarningLb.isHidden = false
        emailWarningLb.text = message
    }
    
    func submitFailure(errorMsg: String?) {
        let alert = UIAlertController(title: "Login failure", message: errorMsg ?? "Something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
