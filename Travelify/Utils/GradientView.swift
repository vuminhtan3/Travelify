//
//  GradientView.swift
//  Travelify
//
//  Created by Minh Tan Vu on 31/07/2023.
//

import UIKit


class GradientViewWhite: UIView {
    
    func setup() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.withAlphaComponent(0.8).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        layer.addSublayer(gradientLayer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
}

class GradientView2: UIView {
    func setup() {
        let startColor = UIColor(red: 0.99, green: 0.84, blue: 0.47, alpha: 1.00)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        gradientLayer.colors = [startColor.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        layer.addSublayer(gradientLayer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
}

class GradientView3: UIView {
    func setup() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        layer.addSublayer(gradientLayer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
}

