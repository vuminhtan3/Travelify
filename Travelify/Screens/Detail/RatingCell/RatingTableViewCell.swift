//
//  RatingTableViewCell.swift
//  Travelify
//
//  Created by Minh Tan Vu on 20/08/2023.
//

import UIKit
import Cosmos

class RatingTableViewCell: UITableViewCell {

    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var userNameLb: UILabel!
    @IBOutlet weak var userRatingView: CosmosView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var userReviewLb: UILabel!
    
    var ratingAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        userNameLb.text = nil
        userReviewLb.text = nil
        userRatingView.prepareForReuse()
        userRatingView.rating = 0
        userRatingView.settings.updateOnTouch = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(userName: String, rating: Double, title: String, reviewDescription: String, ratingAction: (() -> Void)? = nil) {
        self.ratingAction = ratingAction
        self.userNameLb.text = userName
        self.userRatingView.rating = rating
        self.titleLb.text = title
        self.userReviewLb.text = reviewDescription
    }
    
}
