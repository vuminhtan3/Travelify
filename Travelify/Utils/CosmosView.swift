//
//  CosmosView.swift
//  Travelify
//
//  Created by Minh Tan Vu on 20/08/2023.
//

import UIKit
import Cosmos

extension CosmosView {
    func setupCosmosView() {
        self.settings.fillMode = .half
//        self.settings.filledColor = .label
//        self.settings.emptyBorderColor = .label
        self.settings.starSize = 20
        self.settings.filledImage = UIImage(named: "star.fill")?.withRenderingMode(.alwaysTemplate)
        self.settings.emptyImage = UIImage(named: "star")?.withRenderingMode(.alwaysTemplate)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        setupCosmosView()
    }
}
