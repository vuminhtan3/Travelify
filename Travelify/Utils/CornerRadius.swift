//
//  CornerRadius.swift
//  Travelify
//
//  Created by Minh Tan Vu on 20/08/2023.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set (value) {
            layer.cornerRadius = value
            layer.masksToBounds = true
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set (value) {
            layer.borderWidth = value
            layer.masksToBounds = true
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
        set (value) {
            layer.borderColor = value?.cgColor
            layer.masksToBounds = true
            self.clipsToBounds = true
        }
    }
}
