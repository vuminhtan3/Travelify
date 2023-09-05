//
//  AllPhotosViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 06/09/2023.
//

import UIKit
import Kingfisher
import ImageSlideshow

class AllPhotosViewController: UIViewController {

    var imageURLs: [String] = []
    var slideshow = ImageSlideshow()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slideshow.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(slideshow)
        // Tạo mảng chứa các slide
        var imageSlides: [KingfisherSource] = []
        
        for imageUrlString in imageURLs {
            if let imageUrl = URL(string: imageUrlString) {
                // Tạo slide và tải ảnh từ Firebase bằng Kingfisher
                let slide = KingfisherSource(url: imageUrl)
                imageSlides.append(slide)
            }
        }
        
        // Thêm các slide vào slideshow
        slideshow.setImageInputs(imageSlides)
        
        // Cấu hình slideshow
        slideshow.slideshowInterval = 5.0
        slideshow.contentScaleMode = .scaleAspectFit
        
        // Thêm cơ chế đánh dấu trang vào slideshow
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        slideshow.pageIndicator = pageControl
        
        // Start slideshow
        slideshow.setCurrentPage(0, animated: false)
        slideshow.zoomEnabled = true
        
        slideshow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            slideshow.topAnchor.constraint(equalTo: view.topAnchor),
            slideshow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            slideshow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            slideshow.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

