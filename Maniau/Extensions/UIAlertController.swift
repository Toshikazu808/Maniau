//
//  UIAlertController.swift
//  Maniau
//
//  Created by Ryan Kanno on 7/6/21.
//

import UIKit

extension UIAlertController {
   func show() {
      let window = UIWindow(frame: UIScreen.main.bounds)
      window.rootViewController = UIViewController()
      window.windowLevel = UIWindow.Level.alert
      window.makeKeyAndVisible()
      window.rootViewController?.present(self, animated: false, completion: nil)
   }
}
