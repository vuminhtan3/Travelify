//
//  ExtensionDismissKeyboard.swift
//  Travelify
//
//  Created by Minh Tan Vu on 21/07/2023.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    func showLoading(isShow: Bool) {
        if isShow {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = .annularDeterminate
            hud.progress = Float.random(in: 0...1)
            hud.label.text = "Chờ tí..."
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func showAlert(title: String, message: String, completionHandler: (()->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler?()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
