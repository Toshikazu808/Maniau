//
//  UIViewController.swift
//  Maniau
//
//  Created by Ryan Kanno on 7/6/21.
//

import UIKit

extension UIViewController {
   func showError(_ error: String) {
      let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
      self.present(alert, animated: true)
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
      alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
         Defaults.autoLogin.removeObject(forKey: Defaults.autoLoginKey)
         Defaults.autoLogin.setValue(false, forKey: Defaults.autoLoginKey)
      }))
      alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
         Defaults.autoLogin.removeObject(forKey: Defaults.autoLoginKey)
         Defaults.autoLogin.setValue(true, forKey: Defaults.autoLoginKey)
      }))
      self.present(alert, animated: true)
   }
   
   func transitionToHome() {
      let homeVC = storyboard?.instantiateViewController(identifier: K.tabBarVC)
      self.present(homeVC!, animated: true, completion: nil)
   }
}
