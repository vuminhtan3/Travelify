//
//  EditProfileViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 03/08/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Kingfisher
import ActionSheetPicker_3_0
import DropDown

class EditProfileViewController: UIViewController {

    
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var changeImgBtn: UIButton!
    
    @IBOutlet weak var ageTF: CustomUITextField2!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var nameTF: CustomUITextField2!
    @IBOutlet weak var showGenderBtn: UIButton!
    @IBOutlet weak var emailTF: CustomUITextField2!
    @IBOutlet weak var phoneNumberTF: CustomUITextField2!
    @IBOutlet weak var addressTF: CustomUITextField2!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    var isCanBack = false
    let imagePicker = UIImagePickerController()
    let genderDropdown = DropDown()
    let gender: [String] = ["Khác", "Nam", "Nữ"]
    var currentUser: UserProfile?
    private var imageTemp = UIImage(systemName: "person.circle")
    private var databaseRef: DatabaseReference!
    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        avatarImgView.layer.cornerRadius = avatarImgView.frame.height/2
        avatarImgView.layer.borderColor = UIColor.white.cgColor
        avatarImgView.layer.borderWidth = 5
        avatarImgView.layer.masksToBounds = true
        changeImgBtn.layer.cornerRadius = changeImgBtn.frame.height/2
        changeImgBtn.layer.borderColor = UIColor.lightGray.cgColor
        changeImgBtn.layer.borderWidth = 1
        changeImgBtn.layer.masksToBounds = true
        changeImgBtn.backgroundColor = .white
        
        saveBtn.layer.cornerRadius = saveBtn.frame.height/2
        saveBtn.layer.masksToBounds = true
        cancelBtn.layer.cornerRadius = saveBtn.frame.height/2
        cancelBtn.layer.masksToBounds = true
        cancelBtn.isHidden = !isCanBack
        navigationController?.isNavigationBarHidden = !isCanBack
        showGenderBtn.backgroundColor = .systemYellow.withAlphaComponent(0.05)
        showGenderBtn.layer.cornerRadius = showGenderBtn.frame.height/2
        showGenderBtn.layer.borderWidth = 1
        showGenderBtn.layer.borderColor = UIColor.darkGray.cgColor
        showGenderBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        showGenderBtn.layer.masksToBounds = true
        
        setupUITextView()
        emailTF.isEnabled = false
        
        //Check Name đã được điền hay chưa để bật nút save
        nameTF.delegate = self
        saveBtn.isEnabled = false
        
        databaseRef = Database.database().reference()
        
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
                let email = Auth.auth().currentUser?.email as! String
                let address = userData["address"] as? String ?? ""
                let phoneNumber = userData["phoneNumber"] as? String ?? ""
                let bio = userData["bio"] as? String ?? ""
                let image = userData["image"] as? String ?? ""
                
//                self.currentUser = UserProfile(id: id, name: name, gender: gender, age: age, email: email, address: address, phoneNumber: phoneNumber, bio: bio, image: image)
                
                //Download ảnh từ url trong firebase database
                if let imageURL = URL(string: image) {
                    self.avatarImgView.kf.setImage(with: imageURL)
                }
                
                //Update dữ liệu vào màn chỉnh sửa
                self.nameTF.text = name
                self.bioTextView.text = bio
                self.showGenderBtn.setTitle(gender, for: .normal)
                self.ageTF.text = String(age)
                self.emailTF.text = email
                self.addressTF.text = address
                self.phoneNumberTF.text = phoneNumber
                
            }
        }
    }

    func setupUITextView() {
        bioTextView.layer.borderWidth = 1
        bioTextView.layer.borderColor = UIColor.darkGray.cgColor
        bioTextView.layer.cornerRadius = 10
        bioTextView.backgroundColor = .yellow.withAlphaComponent(0.05)
        bioTextView.layer.masksToBounds = true
        bioTextView.isEditable = true
        
        bioTextView.text = "Giới thiệu bản thân"
        bioTextView.textColor = .lightGray
        bioTextView.delegate = self
    }
    
    
    @IBAction func cancelBtnHandle(_ sender: UIButton) {
        let alert = UIAlertController(title: "Thông báo", message: "Dữ liệu bạn chỉnh sửa sẽ không được lưu", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.routeToProfile()
        }
        let cancelAction = UIAlertAction(title: "Huỷ bỏ", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
        
        
    }
    
    
    @IBAction func saveBtnHandle(_ sender: UIButton) {
    
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        if let newName = nameTF.text,
           let newGender = showGenderBtn.title(for: .normal),
           let newAge = Int(ageTF.text ?? ""),
           let newAddress = addressTF.text,
           let newPhoneNumber = phoneNumberTF.text,
           let newBio = bioTextView.text == "Giới thiệu bản thân" ? "N/A" : bioTextView.text {
            databaseRef.child("users").child(currentUser.uid).setValue([
                "id": currentUser.uid,
                "name": newName,
                "gender": newGender,
                "age": newAge,
                "email": currentUser.email,
                "address": newAddress,
                "phoneNumber": newPhoneNumber,
                "bio": newBio
            ])
            
            //Có bug khi thay đổi thông tin mà KHÔNG thay đổi ảnh -> ấn lưu sẽ bị đẩy về ảnh mặc định
            uploadImage(imageTemp!)
        }
        
        let alert = UIAlertController(title: "Thành công", message: "Cập nhật thông tin thành công", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            UserDefaultsService.shared.isFirstTimeSetProfile = false
            self.routeToProfile()
        }))
        present(alert, animated: true)
    }
    
    
    @IBAction func changeImageHandle(_ sender: UIButton) {
        imagePicker.delegate = self
        handleChooseAvatar()
    }
    
    func routeToProfile() {
        navigationController?.popViewController(animated: true)
    }
 
    private func uploadImage(_ image: UIImage) {
        guard let imageData = image.pngData() else {return}
        //Tải ảnh lên storage
        storage.child("user_images/\(Auth.auth().currentUser?.uid ?? "")/user_image.jpg").putData(imageData) { url, error in
            guard error == nil else {
                print("Lỗi: \(error?.localizedDescription)")
                self.showAlert(title: "Lỗi", message: "Không thể tải lên ảnh của bạn")
                return
            }
            //Lấy URL của ảnh từ storage
            self.storage.child("user_images/\(Auth.auth().currentUser?.uid ?? "")/user_image.jpg").downloadURL { url, error in
                guard let downloadURL = url, error == nil else {
                    print("Failed to get image URL")
                    return
                }
                
                //Lưu URL ảnh vào dữ liệu user
                guard let currentUser = Auth.auth().currentUser?.uid else {return}
                let userRef = self.databaseRef.child("users").child(currentUser).child("image")
                userRef.setValue(downloadURL.absoluteString)
                
                print("Image URL: \(downloadURL)")
                
                
            }
        }
        
        
        
    }
    
    @IBAction func changeGenderHandle(_ sender: UIButton) {
        
        genderDropdown.anchorView = showGenderBtn
        genderDropdown.dataSource = gender
        genderDropdown.bottomOffset = CGPoint(x: 0, y: (genderDropdown.anchorView?.plainView.bounds.height)!)
        genderDropdown.topOffset = CGPoint(x: 0, y: -(genderDropdown.anchorView?.plainView.bounds.height)!)
        genderDropdown.direction = .bottom
        genderDropdown.selectionAction = { (index: Int, item: String) in
            self.showGenderBtn.setTitle(self.gender[index], for: .normal)
            self.showGenderBtn.setTitleColor(.black, for: .normal)
        }
        
        genderDropdown.show()
    }
    
    
    func handleChooseAvatar() {
        let alertViewController = UIAlertController(title: "Chọn Ảnh", message: "", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        let gallery = UIAlertAction(title: "Bộ sưu tập", style: .default) { (_) in
            self.openGallery()
        }
        let cancel = UIAlertAction(title: "Huỷ bỏ", style: .cancel) { (_) in
            //cancel
        }
        alertViewController.addAction(camera)
        alertViewController.addAction(gallery)
        alertViewController.addAction(cancel)
        self.present(alertViewController, animated: true)
    }
    
}


//MARK: - TextView Delegate methods
extension EditProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if bioTextView.textColor == .lightGray || bioTextView.text != "Giới thiệu bản thân" {
            bioTextView.text = nil
            bioTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            bioTextView.text = "Giới thiệu bản thân"
            bioTextView.textColor = .lightGray
        }
    }
}

//MARK: - UIImagePicker
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    fileprivate func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            
            /// Cho phép edit ảnh hay không
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        } else {
            let alertWarning = UIAlertController(title: "Lỗi", message: "Camera không có sẵn", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel)
            alertWarning.addAction(cancel)
            self.present(alertWarning, animated: true)
        }
    }
    
    fileprivate func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .photoLibrary
            /// Cho phép edit ảnh hay không
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            //handle image
            self.avatarImgView.image = image
            imageTemp = image
            
        } else if let image = info[.editedImage] as? UIImage {
            //handle image
            self.avatarImgView.image = image
            imageTemp = image
        }
        imagePicker.dismiss(animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true)
    }
}

//MARK: - TextField Delegate methods
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // Kiểm tra nội dung của UITextField để quyết định kích hoạt/ngưng hoạt động nút
        if let text = textField.text, !text.isEmpty {
            saveBtn.isEnabled = true
        } else {
            saveBtn.isEnabled = false
        }
    }
}
