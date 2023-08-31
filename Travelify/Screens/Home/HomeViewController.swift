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

struct Suggestion {
    let backgroundImg: String
    let name: String
    let location: String
}

struct HighRating {
    let image: String
    let name: String
    let location: String
    let description: String
}

class HomeViewController: UIViewController {

    var listPlaces: [Place] = []
    var suggestionPlaces: [Place] = []
    var highRatingPlaces: [Place] = []
    
    @IBOutlet weak var greetingLb: UILabel!
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var suggestCollectionView: UICollectionView!
    @IBOutlet weak var highRatingTableView: UITableView!
    
    private var suggestionDatasource = [Suggestion]()
    private var highRatingDatasource = [HighRating]()
    var databaseRef = Database.database().reference()
    var storage = Storage.storage().reference()
    var currentUserID = Auth.auth().currentUser?.uid
    
    override func loadView() {
        super.loadView()
        DispatchQueue.main.async {
            self.fetchPlacesData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup avatarButton
        avatarBtn.layer.cornerRadius = avatarBtn.frame.height/2
        avatarBtn.clipsToBounds = true
        avatarBtn.layoutIfNeeded()
        avatarBtn.subviews.first?.contentMode = .scaleAspectFill
        downloadAvatar()
        
        print("🤣",listPlaces)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func downloadAvatar() {
        guard let currentUserID = currentUserID else {return}
        databaseRef.child("users").child(currentUserID).observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any] {
//                let id = userData["id"] as! String
                let name = userData["name"] as? String ?? ""
                let gender = userData["gender"] as? String ?? ""
                let age = userData["age"] as? Int ?? 0
                let email = userData["email"] as! String
                let address = userData["address"] as? String ?? ""
//                let phoneNumber = userData["phoneNumber"] as? String ?? ""
                let bio = userData["bio"] as? String ?? ""
                let avatar = userData["avatar"] as? String ?? ""
                
                //Download ảnh từ url trong firebase database
                if let imageURL = URL(string: avatar) {
                    self.avatarBtn.kf.setBackgroundImage(with: imageURL, for: .normal)
                }
                
                self.greetingLb.text = "Xin chào, \(name)"
            }
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
    
    func fetchPlacesData() {
        databaseRef.child("places").observeSingleEvent(of: .value) {[weak self] snapshot in
            guard let self = self else {return}
            guard let placesData = snapshot.value as? [String : [String: Any]] else {
                return
            }
            var fetchedData: [Place] = []
            for (placeID, placeDict) in placesData {
                if let placeID = placeDict["id"] as? String,
                   let placeName = placeDict["name"] as? String,
                   let location = placeDict["location"] as? String,
                   let lat = placeDict["lat"] as? Double,
                   let long = placeDict["long"] as? Double,
                   let avatar = placeDict["avatar"] as? String,
                   let rating = placeDict["rating"] as? Double,
                   let description = placeDict["description"] as? String,
                   let photoArray = placeDict["photos"] as? [String],
                   let reviewsDict = placeDict["reviews"] as? [[String: Any]] {

                    var reviewArray: [Review] = []
                    for reviewDict in reviewsDict {
                        if let reviewID = reviewDict["id"] as? String,
                           let ownerName = reviewDict["ownerName"] as? String,
                           let rating = reviewDict["rating"] as? Double,
                           let title = reviewDict["title"] as? String,
                           let content = reviewDict["content"] as? String,
                           let createdAt = reviewDict["createAt"] as? String,
                           let like = reviewDict["like"] as? Int,
                           let dislike = reviewDict["dislike"] as? Int {

                            let review = Review(id: reviewID, ownerName: ownerName, rating: rating, title: title, content: content, createdAt: createdAt, like: like, dislike: dislike)
                            reviewArray.append(review)
                        }
                    }

                    let place = Place(id: placeID, name: placeName, location: location, lat: lat, long: long, avatar: avatar, rating: rating, description: description, photos: photoArray, reviews: reviewArray)

                    print("😗", place.reviews)
                    fetchedData.append(place)
//                    print(fetchedData)
                }
            }
            self.listPlaces = fetchedData
//            print(self.listPlaces)
            
            self.setupCollectionView()
            self.setupTableView()
            self.suggestCollectionView.reloadData()
            self.highRatingTableView.reloadData()
        }
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
