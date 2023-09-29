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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = false
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        print(currentUser)
        let userRef = databaseRef.child("users").child(currentUser)
        userRef.observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any] {
                let name = userData["name"] as? String ?? ""
                let gender = userData["gender"] as? String ?? ""
                let age = userData["age"] as? Int ?? 0
                let email = userData["email"] as! String
                let address = userData["address"] as? String ?? ""
                let bio = userData["bio"] as? String ?? ""
                let avatar = userData["avatar"] as? String ?? ""
                
                //Download ảnh từ url trong firebase database
                if let imageURL = URL(string: avatar) {
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
    

    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            UserDefaultsService.shared.isLoggedIn = false
            routeToLogin()
            print(Auth.auth().currentUser?.uid)
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
