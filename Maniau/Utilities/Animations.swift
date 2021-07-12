//
//  Animations.swift
//  Maniau
//
//  Created by Ryan Kanno on 7/9/21.
//

import UIKit

struct Animations {
   static func fadeOutViews(background: UIView?, views: [UIView], collection: [UIView]?) {
      UIView.animate(withDuration: 0.4) {
         if let background = background {
            background.alpha = 0
         }
         views.forEach { view in
            view.alpha = 0
         }
         if let collection = collection {
            collection.forEach { item in
               item.alpha = 0
            }
         }
      }
   }
   
   static func fadeInViews(background: UIView?, views: [UIView], collection: [UIView]?) {
      UIView.animate(withDuration: 0.4) {
         if let background = background {
            background.alpha = 0.7
         }
         views.forEach { view in
            view.alpha = 1
         }
         if let collection = collection {
            collection.forEach { item in
               item.alpha = 1
            }
         }
      }
   }
   
   static func convertColorString(_ color: String) -> UIColor {
      switch color {
      case "Blue":
         return UIColor.systemBlue
      case "Teal":
         return UIColor.systemTeal
      case "Green":
         return UIColor.systemGreen
      case "Orange":
         return UIColor.systemOrange
      case "Red":
         return UIColor.systemRed
      case "Yellow":
         return UIColor.systemYellow
      case "Gray":
         return UIColor.systemGray
      default:
         return UIColor.systemTeal
      }
   }
}
