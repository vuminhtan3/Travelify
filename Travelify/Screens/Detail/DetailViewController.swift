//
//  DetailViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 19/08/2023.
//

import UIKit
import Cosmos
import MapKit

class DetailViewController: UIViewController {
    
    var data: [String] = ["akjkbdhjb", "avdbahsbhjdhbshjbssv", "asjkdbsjkbjcbkjdasjkdbsjkbjcbkjdasjkdbsjkbjcbkjdasjkdbsjkbjcbkjdasjkdbsjkbjcbkjdasjkdbsjkbjcbkjdasjkdbsjkbjcbkjdasjkdbsjkbjcbkjd"]
    
    var place: Place?
    
    @IBOutlet weak var largeImgView: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var locationLb: UILabel!
    @IBOutlet weak var totalRatingView: CosmosView!
    @IBOutlet weak var detailInformationLb: UILabel!
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var ratingTableView: UITableView!
    @IBOutlet weak var myRatingTilte: UITextField!
    @IBOutlet weak var myRatingTextView: UITextView!
    @IBOutlet weak var myRatingView: CosmosView!
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var addVideoBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var ratingTableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRatingTableView()
        self.setupData()
        ratingTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        self.ratingTableView.reloadData()
        
    }
    
    //Config Observer Value for tableView to setup tableViewHeight
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.ratingTableView && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    let height = newSize.height
                    print(height)
                    self.ratingTableViewHeight.constant = self.ratingTableView.contentSize.height
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupRatingTableView() {
        ratingTableView.dataSource = self
        ratingTableView.delegate = self
        
        ratingTableView.register(UINib(nibName: "RatingTableViewCell", bundle: nil), forCellReuseIdentifier: "RatingTableViewCell")
    
        ratingTableView.tableHeaderView =
        UIView(frame: CGRect(x: 0, y: 0,width: ratingTableView.frame.width, height: CGFloat.leastNormalMagnitude))
        ratingTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: ratingTableView.frame.width, height: CGFloat.leastNormalMagnitude))
    }
    
//    override func viewWillLayoutSubviews() {
//        self.ratingTableViewHeight.constant = self.ratingTableView.contentSize.height
//    }
    
    private func setupData() {
        for i in 0..<10 {
            self.data.append("Row \(i+1)")
        }
        self.ratingTableView.reloadData()
    }
    
    
    @IBAction func showAllInforBtnTapped(_ sender: UIButton) {
        
        let showAllInforVC = AllInformationViewController(nibName: "AllInformationViewController", bundle: nil) as! AllInformationViewController
        showAllInforVC.contentURL = place?.description
        
        navigationController?.pushViewController(showAllInforVC, animated: true)
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

// Rating TableView Datasource methods
extension DetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ratingTableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell", for: indexPath) as! RatingTableViewCell
//        cell.backgroundColor = .blue
        let model = data[indexPath.row]
        cell.bindData(userName: model, rating: Double(Int.random(in: 1...5)), title: "Something", reviewDescription: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
