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
    
    override func loadView() {
        super.loadView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        contentTextView.text = content
//        contentTextView.isEditable = false
        if let url = URL(string: contentURL) {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        } else {
            let label = UILabel()
            label.text = "Xin lỗi, hiện tại không thể tải thông tin cho địa điểm này. \nVui lòng thử lại sau!"
        }
    }

}
