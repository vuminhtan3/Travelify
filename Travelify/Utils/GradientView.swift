//
//  GradientView.swift
//  Travelify
//
//  Created by Minh Tan Vu on 31/07/2023.
//

import UIKit


class GradientView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.white.withAlphaComponent(1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        layer.addSublayer(gradientLayer)
    }
}
