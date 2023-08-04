//
//  ProfileViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 02/08/2023.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var infoStackView: UIStackView!
    
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var bioLb: UILabel!
    @IBOutlet weak var birthdayLb: UILabel!
    @IBOutlet weak var genderLb: UILabel!
    @IBOutlet weak var emailLb: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var addressLb: UILabel!
    @IBOutlet weak var changeImageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set up navigation bar
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Thông tin"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Chỉnh sửa", image: nil, target: self, action: #selector(routeToEdit))
        navigationController?.navigationBar.backItem?.backButtonTitle = ""
        
        //Set color radius
        avatarImgView.layer.cornerRadius = avatarImgView.frame.height/2
        avatarImgView.layer.masksToBounds = true
        changeImageBtn.layer.cornerRadius = changeImageBtn.frame.height/2
        changeImageBtn.layer.borderColor = UIColor.lightGray.cgColor
        changeImageBtn.layer.borderWidth = 1
        changeImageBtn.layer.masksToBounds = true
        changeImageBtn.backgroundColor = .white
        
        infoStackView.layer.cornerRadius = 20
        infoStackView.layer.masksToBounds = true
        
        logoutBtn.layer.cornerRadius = logoutBtn.frame.height/4
        logoutBtn.layer.masksToBounds = true
    }
    
    @objc func routeToEdit() {
        let editProfileVC = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    func bindData() {
        
    }

    @IBAction func changeImageBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func logoutBtnTapped(_ sender: UIButton) {
    }
}
