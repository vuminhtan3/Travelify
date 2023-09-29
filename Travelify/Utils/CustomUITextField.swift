//
//  CustomTextField.swift
//  Travelify
//
//  Created by Minh Tan Vu on 26/07/2023.
//

import UIKit

//Only bottom line UITextField
class CustomUITextField: UITextField {
    func setup() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: Double(self.frame.height) - 1, width: Double(self.frame.width), height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        self.borderStyle = BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
}

//Custom border UITextField
class CustomUITextField2: UITextField {
    func setup() {
        let width = CGFloat(1)
        let cornerRadius = CGFloat(self.frame.height/2)
        self.layer.borderWidth = width
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.backgroundColor = .yellow.withAlphaComponent(0.05)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
}
//Custom Searchbar UITextField
class CustomSearchBarUITextField2: UITextField {
    func setup() {
        let cornerRadius = CGFloat(self.frame.height/2)
        self.backgroundColor = UIColor(hexString: "#F4F4F4")
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hexString: "#F4F4F4").cgColor
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
}

