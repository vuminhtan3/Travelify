//
//  AllReviewsViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 03/09/2023.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AllReviewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var databaseRef = Database.database().reference()
    var place: Place?
    var reviews: [Review] = []
    var placeID: String?
    var isLoadingData = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func loadView() {
        super.loadView()
        showLoading(isShow: true)
        DispatchQueue.main.async {
            self.fetchReviewsData()
            self.showLoading(isShow: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "RatingTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RatingTableViewCell")
        tableView.allowsSelection = false
    }
    
    func fetchReviewsData() {
        isLoadingData = true
        showLoading(isShow: true)
        guard let place = place else {return}
        placeID = place.id
        
        databaseRef.child("places").child(placeID!).child("reviews").observeSingleEvent(of: .value) {[weak self] snapshot  in
            guard let self = self else {return}
            
            guard let reviewsData = snapshot.value as? [[String: Any]] else {
                print("Không thể phân tích dữ liệu đánh giá.")
                self.showLoading(isShow: false)
                self.isLoadingData = false
                return
            }
            self.showLoading(isShow: false)
            var fetchedReviews: [Review] = []
            
            for reviewInfo in reviewsData {
                if let reviewDict = reviewInfo as? [String : Any],
                   let id = reviewDict["id"] as? Int,
                   let ownerName = reviewDict["ownerName"] as? String,
                   let rating = reviewDict["rating"] as? Double,
                   let title = reviewDict["title"] as? String,
                   let content = reviewDict["content"] as? String,
                   let createdAt = reviewDict["createdAt"] as? String,
                   let like = reviewDict["like"] as? Int,
                   let dislike = reviewDict["dislike"] as? Int {
                    let review = Review(id: id, ownerName: ownerName, rating: rating, title: title, content: content, createdAt: createdAt, like: like, dislike: dislike)
                    fetchedReviews.append(review)
                }
            }
            
            self.reviews = fetchedReviews
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.isLoadingData = false
            }
            
            // Bây giờ mảng "reviews" chứa danh sách các đánh giá từ Firebase
            print("Danh sách đánh giá:")
            for review in self.reviews {
                print("ID: \(review.id), Owner: \(review.ownerName ?? ""), Rating: \(review.rating), Title: \(review.title), Content: \(review.content)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell", for: indexPath) as! RatingTableViewCell
        
        let model = reviews[indexPath.item]
        cell.bindData(userName: model.ownerName!, createdAt: model.createdAt!, rating: model.rating!, title: model.title!, reviewDescription: model.content!)
        
        return cell
    }
    
}
