//
//  RatingTableViewCell.swift
//  Travelify
//
//  Created by Minh Tan Vu on 20/08/2023.
//

import UIKit
import Cosmos
import FloatRatingView

class RatingTableViewCell: UITableViewCell {

    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var userNameLb: UILabel!
    @IBOutlet weak var createdAtLb: UILabel!
    @IBOutlet weak var userRatingView: FloatRatingView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var userReviewLb: UILabel!
    
    var ratingAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        userRatingView.settings.updateOnTouch = false
        userRatingView.editable = false
    }
    
    override func prepareForReuse() {
        userNameLb.text = nil
        userReviewLb.text = nil
//        userRatingView.prepareForReuse()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(userName: String, createdAt: String, rating: Double, title: String, reviewDescription: String, ratingAction: (() -> Void)? = nil) {
        self.ratingAction = ratingAction
        self.userNameLb.text = userName
        self.createdAtLb.text = createdAt
        self.userRatingView.rating = rating
        self.titleLb.text = title
        self.userReviewLb.text = reviewDescription
    }
    
}
