//
//  UIViewController+Extensions.swift
//  TestApp
//
//  Created by Gourav on 08/06/25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String,
                   message: String,
                   okTitle: String = "OK",
                   cancelTitle: String? = nil,
                   okHandler: (() -> Void)? = nil,
                   cancelHandler: (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let cancel = cancelTitle {
            alertController.addAction(UIAlertAction(title: cancel, style: .cancel) { _ in
                cancelHandler?()
            })
        }
        
        alertController.addAction(UIAlertAction(title: okTitle, style: .default) { _ in
            okHandler?()
        })

        self.present(alertController, animated: true, completion: nil)
    }
}
