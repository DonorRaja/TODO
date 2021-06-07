//
//  Extension.swift
//  TODO
//
//  Created by DonorRaja on 7/06/21.
//

import Foundation

//This is your shared class
import UIKit

 class SharedClass: NSObject {

 static let sharedInstance = SharedClass()

 //Here write your code....

 private override init() {
 }
}

extension  UIViewController {

    func showAlert(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
        })
        alert.addAction(ok)
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}
