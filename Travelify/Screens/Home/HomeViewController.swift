//
//  HomeViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 30/07/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Kingfisher

class HomeViewController: UIViewController {

    var listPlaces: [Place] = []
    
    @IBOutlet weak var greetingLb: UILabel!
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var searchBarTF: CustomSearchBarUITextField2!
    @IBOutlet weak var suggestCollectionView: UICollectionView!
    @IBOutlet weak var highRatingTableView: UITableView!
    
    var databaseRef = Database.database().reference()
    var storage = Storage.storage().reference()
    var currentUserID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup avatarButton
        searchBarTF.delegate = self
        
        avatarImgView.layer.cornerRadius = avatarImgView.frame.height/2
        avatarImgView.clipsToBounds = true
        downloadAvatar()
        
        showLoading(isShow: true)
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            appDelegate.fetchPlacesData { [weak self] places in
                guard let self = self else { return }
                self.showLoading(isShow: false)
                
                self.listPlaces = places
                self.setupCollectionView()
                self.setupTableView()
            }
        }
        
        print("🤣",listPlaces)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.main.async {
            self.downloadAvatar()
//            self.fetchPlacesData()
        }
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private func downloadAvatar() {
        guard let currentUserID = currentUserID else {return}
        databaseRef.child("users").child(currentUserID).observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any] {
//                let id = userData["id"] as! String
                let name = userData["name"] as? String ?? ""
//                let gender = userData["gender"] as? String ?? ""
//                let age = userData["age"] as? Int ?? 0
//                let email = userData["email"] as! String
//                let address = userData["address"] as? String ?? ""
//                let phoneNumber = userData["phoneNumber"] as? String ?? ""
//                let bio = userData["bio"] as? String ?? ""
                let avatar = userData["avatar"] as? String ?? ""
                
                //Download ảnh từ url trong firebase database
                if let imageURL = URL(string: avatar) {
                    self.avatarImgView.kf.setImage(with: imageURL)
                }
                
                self.greetingLb.text = "Xin chào, \(name)"
            }
        }
    }
    
    func fetchPlacesData() {
        FirebaseManager.shared.loadingHandler = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.showLoading(isShow: true)
                } else {
                    self?.showLoading(isShow: false)
                }
            }
        }
        
        FirebaseManager.shared.fetchPlacesData { [weak self] places in
            guard let self = self else { return }

            self.listPlaces = places
            self.setupCollectionView()
            self.setupTableView()
        }
    }
    
    private func setupCollectionView() {
        suggestCollectionView.delegate = self
        suggestCollectionView.dataSource = self
        suggestCollectionView.register(UINib(nibName: "SuggestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SuggestCollectionViewCell")
        
        if let flowLayout = suggestCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            flowLayout.minimumLineSpacing = 20
            flowLayout.minimumInteritemSpacing = 0
            
            flowLayout.estimatedItemSize = .zero
            flowLayout.itemSize = CGSize(width: 130, height: suggestCollectionView.frame.height)
            flowLayout.scrollDirection = .horizontal
        }
        
        suggestCollectionView.showsHorizontalScrollIndicator = false
        self.suggestCollectionView.reloadData()
    }
    
    private func setupTableView() {
        highRatingTableView.delegate = self
        highRatingTableView.dataSource = self
        highRatingTableView.register(UINib(nibName: "HighRatingTableViewCell", bundle: nil), forCellReuseIdentifier: "HighRatingTableViewCell")
        self.highRatingTableView.reloadData()
    }
   
    
    @IBAction func avatarBtnTapped(_ sender: UIButton) {
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
}


//MARK: - CollectionView Datasource methods
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = suggestCollectionView.dequeueReusableCell(withReuseIdentifier: "SuggestCollectionViewCell", for: indexPath) as! SuggestCollectionViewCell
        cell.layer.cornerRadius = 10
        
        let suggestionModel = listPlaces[indexPath.row]
        cell.bindData(name: suggestionModel.name!, backgroundImage: suggestionModel.avatar!, rating: suggestionModel.rating!)
        return cell
        
    }
    
    
}

//MARK: - CollectionView Delegate Methods
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        routeToDetail(dataSource: listPlaces, with: indexPath)
        suggestCollectionView.deselectItem(at: indexPath, animated: true)
    }
}

//MARK: - TableView HighRating Datasource Methods
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = highRatingTableView.dequeueReusableCell(withIdentifier: "HighRatingTableViewCell", for: indexPath) as! HighRatingTableViewCell
        
        let highRatingModel = listPlaces[indexPath.row]
        cell.binData(image: highRatingModel.avatar!, name: highRatingModel.name!, location: highRatingModel.location!, description: highRatingModel.description!)
        
        return cell
        
    }
}

//MARK: - TableView HighRating Delegate Methods
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        routeToDetail(dataSource: listPlaces, with: indexPath)
        highRatingTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
//MARK: - Navigate Screen
extension HomeViewController {
    func routeToDetail(dataSource: [Place], with indexPath: IndexPath) {
        let detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVC.place = dataSource[indexPath.item]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: - SearchBar Delegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Tạo và chuyển hướng sang UIViewController mới khi UITextField được nhấp vào
        let searchVC = SearchViewController(nibName: "SearchViewController", bundle: nil)
        navigationController?.pushViewController(searchVC, animated: true)
        searchVC.isFromHome = true
        // Trả về false để không hiển thị bàn phím khi tap vào UITextField
        return false
    }
}
