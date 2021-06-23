//
//  Extensions.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/22/21.
//

import UIKit

extension UIViewController {
   func showError(_ error: String) {
      let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
      present(alert, animated: true)
   }
   
   func clearTextFields(_ emailTF:  UITextField, _ pwTF: UITextField) {
      emailTF.text = ""
      emailTF.placeholder = "email"
      pwTF.text = ""
      pwTF.placeholder = "password"
   }
}


extension Date {
   var month: String {
      let m = DateFormatter()
      m.dateFormat = "MMMM"
      return m.string(from: self)
   }
}


