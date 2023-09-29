//
//  CosmosView.swift
//  Travelify
//
//  Created by Minh Tan Vu on 20/08/2023.
//

import UIKit
import Cosmos
import FloatRatingView

extension CosmosView {
    func setupCosmosView() {
        self.settings.fillMode = .half
        self.settings.filledImage = UIImage(named: "star.fill")?.withRenderingMode(.alwaysOriginal)
        self.settings.emptyImage = UIImage(named: "star")?.withRenderingMode(.alwaysOriginal)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        setupCosmosView()
    }
}

extension FloatRatingView {
    func setupFloatRatingView() {
        self.emptyImage = UIImage(named: "star")
        self.fullImage = UIImage(named: "star.fill")
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        setupFloatRatingView()
    }
}
