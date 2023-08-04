//
//  HighRatingTableViewCell.swift
//  Travelify
//
//  Created by Minh Tan Vu on 30/07/2023.
//

import UIKit

class HighRatingTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var locationLb: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var descriptionLb: UILabel!
    
    var favoriteBtnAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        imgView.image = nil
        nameLb.text = nil
        locationLb.text = nil
        descriptionLb.text = nil
        favoriteBtn.setImage(nil, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favoriteBtnTapped(_ sender: UIButton) {
        favoriteBtnAction?()
    }
    
    func binData(image: String, name: String, location: String, description: String, favoriteBtnAction: (()-> Void)?) {
        self.favoriteBtnAction = favoriteBtnAction
        imgView.image = UIImage(named: image)
        nameLb.text = name
        locationLb.text = location
        descriptionLb.text = description
    }
    
}
