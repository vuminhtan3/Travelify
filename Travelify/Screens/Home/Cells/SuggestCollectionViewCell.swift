//
//  SuggestCollectionViewCell.swift
//  Travelify
//
//  Created by Minh Tan Vu on 30/07/2023.
//

import UIKit

class SuggestCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var backgroundImgView: UIImageView!
    @IBOutlet weak var gradientView: GradientView3!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImgView.layer.cornerRadius = 5
    }

    override func prepareForReuse() {
        nameLb.text = nil
        backgroundImgView.image = nil
    }
    
    func bindData(name: String, location: String, backgroundImage: String) {
        nameLb.text = name
        backgroundImgView.image = UIImage(named: backgroundImage)
    }
}
