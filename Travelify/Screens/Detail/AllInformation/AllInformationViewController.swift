//
//  AllInformationViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 28/08/2023.
//

import UIKit
import WebKit

class AllInformationViewController: UIViewController, WKNavigationDelegate {
    
    var contentURL: String!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoading(isShow: true)
        // Kiểm tra xem URL có hợp lệ không
        if let url = URL(string: contentURL) {
            let request = URLRequest(url: url)
           
            DispatchQueue.main.async {
                self.webView.navigationDelegate = self
                self.webView.load(request)
            }
           
        } else {
            showLoading(isShow: false)
            // Xử lý URL không hợp lệ
            let label = UILabel()
            label.text = "Xin lỗi, hiện tại không thể tải thông tin cho địa điểm này. \nVui lòng thử lại sau!"
            label.textAlignment = .center
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            // Xây dựng constraints cho label để nó lấp đầy toàn bộ view
            label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showLoading(isShow: false)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showLoading(isShow: false)
    }
}
