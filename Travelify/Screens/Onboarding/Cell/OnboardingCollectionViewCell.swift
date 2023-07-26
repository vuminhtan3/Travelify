//
//  OnboardingCollectionViewCell.swift
//  Travelify
//
//  Created by Minh Tan Vu on 07/07/2023.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var backgroundImgView: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var descritionLb: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var nextBtnAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nextBtn.layer.cornerRadius = nextBtn.bounds.height/4
        nextBtn.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImgView.image = nil
        titleLb.text = nil
        descritionLb.text = nil
    }
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        nextBtnAction?()
    }
    
    func bindData(index: Int, image: String, title: String, description: String, nextBtnAction: (() -> Void)?) {
        if index == 2 {
            nextBtn.setTitle("Bắt đầu", for: .normal)
        } else {
            nextBtn.setTitle("Tiếp theo", for: .normal)
        }
        
        self.nextBtnAction = nextBtnAction
        backgroundImgView.image = UIImage(named: image)
        titleLb.text = title
        descritionLb.text = description
    }
    
}

class GradientView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        layer.addSublayer(gradientLayer)
    }
}
