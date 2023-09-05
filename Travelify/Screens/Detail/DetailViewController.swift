//
//  DetailViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 19/08/2023.
//

import UIKit
import Kingfisher
import Cosmos
import MapKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class DetailViewController: UIViewController {
    
    let currentUser = Auth.auth().currentUser
    var databaseRef = Database.database().reference()
    var storage = Storage.storage().reference()
    var place: Place?
    var reviews: [Review]?
    var photos: [String]?
    
    @IBOutlet weak var largeImgView: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var locationLb: UILabel!
    @IBOutlet weak var totalRatingView: CosmosView!
    @IBOutlet weak var totalRatingLb: UILabel!
    @IBOutlet weak var detailInformationLb: UILabel!
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var ratingTableView: UITableView!
    @IBOutlet weak var myRatingTilte: UITextField!
    @IBOutlet weak var myRatingTextView: UITextView!
    @IBOutlet weak var textViewPlaceholderLb: UILabel!
    @IBOutlet weak var myRatingView: CosmosView!
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var addVideoBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var ratingTableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRatingTableView()
        ratingTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        totalRatingView.settings.updateOnTouch = false
        totalRatingView.settings.fillMode = .precise
        myRatingView.rating = 0
        myRatingView.settings.fillMode = .half
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = place?.name
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.backItem?.backButtonTitle = ""
        
        showLoading(isShow: true)
        fetchInformationData()
        fetchPhotosURL()
        setupMapView()
        setupTextView()
        
        self.reviews = place?.reviews
        
        self.ratingTableView.reloadData()
        
    }
    
    //Config Observer Value for tableView to setup tableViewHeight
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.ratingTableView && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    let height = newSize.height
//                    print(height)
                    self.ratingTableViewHeight.constant = self.ratingTableView.contentSize.height
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func fetchInformationData() {
        guard let place = place else {return}
        if let avatarURL = URL(string: place.avatar!) {
            largeImgView.kf.setImage(with: avatarURL)
        }
        nameLb.text = place.name
        locationLb.text = place.location
        totalRatingView.rating = place.rating!
        totalRatingLb.text = String(format: "%.1f", place.rating!)
        detailInformationLb.text = place.description
        imgView1.kf.setImage(with: URL(string: place.photos![0]))
        imgView2.kf.setImage(with: URL(string: place.photos![1]))
        imgView3.kf.setImage(with: URL(string: place.photos![2]))
       
        showLoading(isShow: false)
    }
    
    func setupRatingTableView() {
        ratingTableView.dataSource = self
        ratingTableView.delegate = self
        
        ratingTableView.allowsSelection = false
        
        ratingTableView.register(UINib(nibName: "RatingTableViewCell", bundle: nil), forCellReuseIdentifier: "RatingTableViewCell")
    
        ratingTableView.tableHeaderView =
        UIView(frame: CGRect(x: 0, y: 0,width: ratingTableView.frame.width, height: CGFloat.leastNormalMagnitude))
        ratingTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: ratingTableView.frame.width, height: CGFloat.leastNormalMagnitude))
    }
    
    func setupTextView() {
        myRatingTextView.delegate = self
        
    }
    
    @IBAction func showAllInforBtnTapped(_ sender: UIButton) {
        guard let place = place else {return}
        let showAllInforVC = AllInformationViewController(nibName: "AllInformationViewController", bundle: nil)
        showAllInforVC.contentURL = place.url
        
        navigationController?.pushViewController(showAllInforVC, animated: true)
    }
    
    
    @IBAction func showPhotoGallery(_ sender: UIButton) {
        let photosVC = AllPhotosViewController(nibName: "AllPhotosViewController", bundle: nil)
        photosVC.imageURLs = self.photos ?? []
        navigationController?.pushViewController(photosVC, animated: true)
    }
    
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        guard let currentUser = self.currentUser else {
            return
        }
        
        let id = place?.reviews?.count
        let ownerName = currentUser.displayName!
        let rating = myRatingView.rating
        let title = myRatingTilte.text
        let content = myRatingTextView.text
        let createdAt = getCurrentTimestamp()
        
        let newReview = Review(id: id!, ownerName: ownerName, rating: rating, title: title, content: content, createdAt: createdAt, like: 0, dislike: 0)
        guard let place = place else {return}
        
        if validateForm(title: title ?? "", content: content ?? "", rating: rating) {
            showLoading(isShow: true)
            addReviewToFirebase(placeID: place.id!, review: newReview)
        }
    }
    
    @IBAction func addVideoTapped(_ sender: UIButton) {
        showAlert(title: "Xin lỗi ☺️", message: "Xin lỗi, tính năng đang phát triển! Sẽ sớm có thôi! ☺️")
    }
    
    @IBAction func addPhotoTapped(_ sender: UIButton) {
        showAlert(title: "Xin lỗi ☺️", message: "Xin lỗi, tính năng đang phát triển! Sẽ sớm có thôi! ☺️")
    }
    
    @IBAction func showAllReviewBtnTapped(_ sender: UIButton) {
        let allReviewsVC = AllReviewsViewController(nibName: "AllReviewsViewController", bundle: nil)
        allReviewsVC.place = self.place
        navigationController?.pushViewController(allReviewsVC, animated: true)
    }
    
}

//MARK: - Rating TableView Datasource methods
extension DetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ratingTableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell", for: indexPath) as! RatingTableViewCell
        if let reviews = place?.reviews {
            let model = reviews[Int.random(in: 0..<reviews.count)]
            cell.bindData(userName: model.ownerName!, createdAt: model.createdAt!, rating: model.rating!, title: model.title!, reviewDescription: model.content!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ratingTableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - Setup MapView
extension DetailViewController: MKMapViewDelegate {
    func setupMapView() {
        guard let place = place else {return}
        mapView.delegate = self
        let initialLocation = CLLocationCoordinate2D(latitude: place.lat!, longitude: place.long!)
        let anotation = MKPointAnnotation()
        anotation.coordinate = initialLocation
        anotation.title = place.name ?? "Địa điểm đã chọn"
        mapView.addAnnotation(anotation)
        
        let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 400, longitudinalMeters: 400)
        mapView.setRegion(region, animated: true)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        mapView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
//            let locationInView = gestureRecognizer.location(in: mapView)
//            let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
            // Open the map at the tapped location
            openMapAtCoordinate()
        }
    }
    
    func openMapAtCoordinate() {
        guard let place = place else {return}
        let coordinate = CLLocationCoordinate2D(latitude: place.lat!, longitude: place.long!)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.openInMaps(launchOptions: nil)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation,
              let coordinate = view.annotation?.coordinate else {
            return
        }
        
        // Tạo một placemark
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = annotation.title as! String
        
        // Mở ứng dụng Maps với vị trí đã đánh dấu
        mapItem.openInMaps(launchOptions: nil)
        
        // Bỏ chọn đánh dấu để cho phép chọn lại lần tiếp theo
        mapView.deselectAnnotation(annotation, animated: false)
    }
}

//MARK: - TextViewDelegate
extension DetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewPlaceholderLb.isHidden = true
        myRatingTextView.selectAll(myRatingTextView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if myRatingTextView.text.isEmpty {
            textViewPlaceholderLb.isHidden = false
        }
    }
}

//MARK: - Add Review to Firebase
extension DetailViewController {
    func addReviewToFirebase(placeID: String, review: Review) {
        // Tạo một dictionary chứa thông tin của đánh giá
        let reviewData: [String: Any] = [
            "id": review.id,
            "ownerName": review.ownerName ?? "Unknown",
            "rating": review.rating,
            "title": review.title,
            "content": review.content,
            "createdAt": review.createdAt, // Lấy thời gian hiện tại
            "like": review.like,
            "dislike": review.dislike
        ]
        
        // Thêm dữ liệu đánh giá vào Firebase theo đường dẫn tương ứng
        let reviewRef = databaseRef.child("places").child(placeID).child("reviews").child("\(review.id)")
        reviewRef.setValue(reviewData) { error, _ in
            if let error = error {
                print("Error adding review to Firebase: \(error)")
            } else {
                print("Review added to Firebase successfully")
                
                self.myRatingTilte.text = ""
                self.myRatingTextView.text = ""
                self.myRatingView.rating = 0
                self.reviews!.append(review)
                self.place?.reviews = self.reviews
                self.showLoading(isShow: false)
                self.showAlert(title: "Thành công", message: "Đã gửi đánh giá thành công")
//                self.fetchPlacesData()
            }
        }
        
        // Tính toán lại totalRating
        reCalculateRating(placeID: placeID, review: review)
    }

    // Hàm để lấy thời gian hiện tại dưới dạng timestamp
    func getCurrentTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    func fetchPlacesData() {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        DispatchQueue.main.async {
            homeVC.fetchPlacesData()
        }
    }
    
    func reCalculateRating(placeID: String, review: Review) {
        
        let newRating = review.rating
        let totalRating = place?.reviews?.reduce(0.0, { $0 + $1.rating! }) ?? 0.0
        let newAverageRating = (totalRating + newRating!) / Double(place?.reviews?.count ?? 1 + 1)
        
        self.place?.rating = newAverageRating
        
        DispatchQueue.main.async {
            self.totalRatingView.rating = newAverageRating
            self.totalRatingLb.text = String(format: "%.1f", newAverageRating)
        }
        
        let updatedRatingData: [String: Any] = [
            "rating": place?.rating
        ]
        
        databaseRef.child("places").child(placeID).updateChildValues(updatedRatingData) { error, _ in
            if let error = error {
                print("Error updating rating on Firebase: \(error)")
            } else {
                print("Rating updated on Firebase successfully")
            }
        }
    }
    
}

//MARK: - Validate Form
extension DetailViewController {
    private func validateForm(title: String, content: String, rating: Double) -> Bool {
        var isValid = true
        
        if title.isEmpty {
            isValid = false
            sendReviewValidateFailure(message: "Vui lòng nhập tiêu đề")
        }
        
        if content.isEmpty {
            isValid = false
            sendReviewValidateFailure(message: "Vui lòng nhập nội dung")
        }
        
        if rating == 0 {
            isValid = false
            sendReviewValidateFailure(message: "Vui lòng cho biết số sao bạn đánh giá cho địa điểm này")
        }
        
        return isValid
    }
    
    func sendReviewValidateFailure(message: String?) {
        self.showAlert(title: "Thông báo", message: message!)
    }
}

//MARK: - Show All Photos
extension DetailViewController {
    func fetchPhotosURL() {
        showLoading(isShow: true)
        guard let place = place else {return}
        databaseRef.child("places").child(place.id!).child("photos").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else {return}
            guard let photos = snapshot.value as? [String] else {
                print("Không thể phân tích dữ liệu ảnh")
                return
            }
            self.showLoading(isShow: false)
            
            var fetchedImageURLs: [String] = []
            for photo in photos {
                fetchedImageURLs.append(photo)
            }
            self.photos = fetchedImageURLs
            print(photos)
        }
    }
}
