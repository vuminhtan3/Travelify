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
    var reviews: [Review?] = []
    
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
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = place?.name
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.backItem?.backButtonTitle = ""
        
        fetchInformationData()
        setupMapView()
        setupTextView()
        
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
        
        let showAllInforVC = AllInformationViewController(nibName: "AllInformationViewController", bundle: nil)
        showAllInforVC.contentURL = place?.url
        
        navigationController?.pushViewController(showAllInforVC, animated: true)
    }
    
    
    @IBAction func showPhotoGallery(_ sender: UIButton) {
    }
    
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func addVideoTapped(_ sender: UIButton) {
        showAlert(title: "Xin lỗi ☺️", message: "Xin lỗi, tính năng đang phát triển! Sẽ sớm có thôi! ☺️")
    }
    
    @IBAction func addPhotoTapped(_ sender: UIButton) {
        showAlert(title: "Xin lỗi ☺️", message: "Xin lỗi, tính năng đang phát triển! Sẽ sớm có thôi! ☺️")
    }
    
    @IBAction func showAllReviewBtnTapped(_ sender: UIButton) {
        
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
            let model = reviews[indexPath.item]
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
        let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 400, longitudinalMeters: 400)
        mapView.setRegion(region, animated: true)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let locationInView = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
            // Open the map at the tapped location
            openMapAtCoordinate(coordinate)
        }
    }
    
    func openMapAtCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.openInMaps(launchOptions: nil)
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
