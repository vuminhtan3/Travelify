//
//  SuggestCollectionViewCell.swift
//  Travelify
//
//  Created by Minh Tan Vu on 30/07/2023.
//

import UIKit
import Cosmos
import Kingfisher

class SuggestCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var backgroundImgView: UIImageView!
    @IBOutlet weak var gradientView: GradientViewWhite!
    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImgView.layer.cornerRadius = 5
        
        ratingView.settings.starSize = 12
        ratingView.settings.fillMode = .precise
        ratingView.settings.updateOnTouch = false
    }

    override func prepareForReuse() {
        nameLb.text = nil
        backgroundImgView.image = nil
        ratingView.prepareForReuse()
    }
    
    func bindData(name: String, backgroundImage: String, rating: Double) {
        self.nameLb.text = name
        self.ratingView.rating = rating
        if let imgURL = URL(string: backgroundImage) {
            self.backgroundImgView.kf.setImage(with: imgURL)
        }
    }
}
