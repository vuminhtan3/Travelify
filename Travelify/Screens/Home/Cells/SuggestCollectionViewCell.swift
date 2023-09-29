//
//  SuggestCollectionViewCell.swift
//  Travelify
//
//  Created by Minh Tan Vu on 30/07/2023.
//

import UIKit
import Cosmos
import Kingfisher
import FloatRatingView

class SuggestCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var backgroundImgView: UIImageView!
    @IBOutlet weak var gradientView: GradientViewWhite!
//    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var ratingView: FloatRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImgView.layer.cornerRadius = 5
        
        ratingView.emptyImage = UIImage(named: "star")
        ratingView.fullImage = UIImage(named: "star.fill")
        ratingView.editable = false
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLb.text = nil
        backgroundImgView.image = nil
//        ratingView.prepareForReuse()
    }
    
    func bindData(name: String, backgroundImage: String, rating: Double) {
        self.nameLb.text = name
        self.ratingView.rating = rating
        if let imgURL = URL(string: backgroundImage) {
            self.backgroundImgView.kf.setImage(with: imgURL)
        }
    }
}
