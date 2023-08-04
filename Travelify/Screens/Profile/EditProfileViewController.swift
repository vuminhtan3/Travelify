//
//  EditProfileViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 03/08/2023.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var nameTF: CustomUITextField2!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var emailTF: CustomUITextField2!
    @IBOutlet weak var phoneNumberTF: CustomUITextField2!
    @IBOutlet weak var addressTF: CustomUITextField2!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        saveBtn.layer.cornerRadius = saveBtn.frame.height/4
        saveBtn.layer.masksToBounds = true
        setupUITextView()
    }


    func setupUITextView() {
        bioTextView.layer.cornerRadius = 10
        bioTextView.layer.borderColor = UIColor.darkGray.cgColor
        bioTextView.layer.borderWidth = 1
        bioTextView.backgroundColor = .yellow.withAlphaComponent(0.05)
        bioTextView.layer.masksToBounds = true
        bioTextView.isEditable = true
    }
}

extension CustomUITextField2: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 18
    }
}
