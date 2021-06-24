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
   
   func clearLoginTextFields(_ emailTF:  UITextField, _ pwTF: UITextField) {
      emailTF.text = ""
      emailTF.placeholder = "email"
      pwTF.text = ""
      pwTF.placeholder = "password"
   }
   
   func askToSavePw() {
      let alert = UIAlertController(
         title: "Do you want to save your login information?",
         message: "Enabling automatic login will save your username and password to your device.",
         preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
      alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
         Defaults.autoLogin.removeObject(forKey: Defaults.autoLoginKey)
         Defaults.autoLogin.setValue(true, forKey: Defaults.autoLoginKey)
      }))
      present(alert, animated: true)
   }
}


extension Date {
   var month: String {
      let m = DateFormatter()
      m.dateFormat = "MMMM"
      return m.string(from: self)
   }
}
