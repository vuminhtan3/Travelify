//
//  CustomStyleTabBarContentView.swift
//  Travelify
//
//  Created by Minh Tan Vu on 24/08/2023.
//

import Foundation
import ESTabBarController_swift

class CustomStyleTabBarContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        /// Normal
        iconColor = UIColor.lightGray
        
        /// Selected
        highlightIconColor = UIColor.black
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
