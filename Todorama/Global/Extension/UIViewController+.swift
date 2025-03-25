//
//  UIViewController+.swift
//  Todorama
//
//  Created by 최정안 on 3/25/25.
//

import UIKit

extension UIViewController  {
    func showAlert(text: String, action: (() -> Void)? = nil) {
    
        let alert = UIAlertController(title: Strings.Alert.title.text, message: text, preferredStyle: .alert)
        var button : UIAlertAction
        if let action {
            button = UIAlertAction(title: Strings.Alert.retry.text, style: .default) { _ in
                action()
            }
        } else {
            button = UIAlertAction(title: Strings.Global.cancel.text, style: .default)  { _ in
            }
        }

        alert.addAction(button)
        present(alert, animated: true)
    }
}
