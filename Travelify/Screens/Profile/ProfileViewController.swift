//
//  ProfileViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 02/08/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var infoStackView: UIStackView!
    
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var bioLb: UILabel!
    @IBOutlet weak var ageLb: UILabel!
    @IBOutlet weak var genderLb: UILabel!
    @IBOutlet weak var emailLb: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var addressLb: UILabel!
    @IBOutlet weak var changeImageBtn: UIButton!
    
    var databaseRef = Database.database().reference()
    var currentUser: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set up navigation bar
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Thông tin"
        
        let rightBarBtnItem = UIBarButtonItem(title: "Chỉnh sửa", style: .plain, target: self, action: #selector(routeToEdit))
        navigationItem.rightBarButtonItem = rightBarBtnItem
        
        navigationController?.navigationBar.backItem?.backButtonTitle = ""
        
        //Set color radius
        avatarImgView.layer.cornerRadius = avatarImgView.frame.height/2
        avatarImgView.layer.borderColor = UIColor.white.cgColor
        avatarImgView.layer.borderWidth = 5
        avatarImgView.layer.masksToBounds = true
        changeImageBtn.layer.cornerRadius = changeImageBtn.frame.height/2
        changeImageBtn.layer.borderColor = UIColor.lightGray.cgColor
        changeImageBtn.layer.borderWidth = 1
        changeImageBtn.layer.masksToBounds = true
        changeImageBtn.backgroundColor = .white
        changeImageBtn.isHidden = true
        
        infoStackView.layer.cornerRadius = 20
        infoStackView.layer.masksToBounds = true
        
        logoutBtn.layer.cornerRadius = logoutBtn.frame.height/2
        logoutBtn.layer.masksToBounds = true
    }
    
    @objc func routeToEdit() {
        let editProfileVC = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        editProfileVC.isCanBack = true
        navigationController?.pushViewController(editProfileVC, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        let userRef = databaseRef.child("users").child(currentUser)
        userRef.observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any] {
                let id = userData["id"] as! String
                let name = userData["name"] as? String ?? ""
                let gender = userData["gender"] as? String ?? ""
                let age = userData["age"] as? Int ?? 0
                let email = userData["email"] as! String
                let address = userData["address"] as? String ?? ""
                let phoneNumber = userData["phoneNumber"] as? String ?? ""
                let bio = userData["bio"] as? String ?? ""
                let image = userData["image"] as? String ?? ""
                
                //Download ảnh từ url trong firebase database
                if let imageURL = URL(string: image) {
                    self.avatarImgView.kf.setImage(with: imageURL)
                }
                
                //Update dữ liệu vào màn hình thông tin
                self.nameLb.text = name
                self.bioLb.text = bio
                self.ageLb.text = String(age)
                self.genderLb.text = gender
                self.emailLb.text = email
                self.addressLb.text = address
            }
        }
    }
    
    func bindData() {
        
    }

    @IBAction func changeImageBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            UserDefaultsService.shared.isLoggedIn = false
            routeToLogin()
        } catch let signOutError as NSError {
            let alert = UIAlertController(title: "Lỗi", message: signOutError.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    func routeToLogin() {
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: loginVC)
        
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else {return}
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}
