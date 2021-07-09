//
//  UIViewController.swift
//  Maniau
//
//  Created by Ryan Kanno on 7/6/21.
//

import UIKit
import Firebase
import FirebaseAuth

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
   
   func validateFields(_ email: String, _ password: String) -> String? {
      if email == "" {
         return "Please enter your email."
      }
      if password == "" {
         return "Please enter a password"
      }
      return nil
   }
   
   func askToSavePw() {
      let alert = UIAlertController(
         title: "Do you want to save your login information?",
         message: "Enabling automatic login will save your username and password to your device.",
         preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
         print("autoLogin set value to false")
      }))
      alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
         print("autoLogin set value to true")
      }))
      self.present(alert, animated: true)
   }
   
   func transitionToHome(_ email: String) {
      let tabVC = storyboard?.instantiateViewController(identifier: K.tabBarVC) as! UITabBarController
      if let vcs = tabVC.viewControllers,
         let navVC = vcs.first as? UINavigationController,
         let homeVC = navVC.topViewController as? HomeVC {
         homeVC.email = email
      }
      self.present(tabVC, animated: true, completion: nil)
   }
   
   func saveUserEmailToDefaults(_ email: String) {
      Defaults.userInfo.removeObject(forKey: Defaults.userInfoKey)
      Defaults.userInfo.setValue(email, forKey: Defaults.userInfoKey)
   }
   
   func displayLoading(with view: UIView, and indicator: UIActivityIndicatorView) {
      if indicator.isAnimating {
         indicator.stopAnimating()
         indicator.alpha = 0
         view.alpha = 0
      } else {
         view.alpha = 0.5
         indicator.alpha = 1
         indicator.startAnimating()
      }
   }
}
