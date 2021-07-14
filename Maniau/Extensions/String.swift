//
//  String.swift
//  Maniau
//
//  Created by Ryan Kanno on 7/6/21.
//

import UIKit

extension String {
//   func toTimeInterval(timeString: String) -> TimeInterval {
//      let date = Date()
//
//
//
////      switch timeString {
////      case "Never":
////         return 0
////      case "Every Day":
////         print("placeholder")
////      case "Every Week":
////         print("placeholder")
////      case "Every 2 Weeks":
////         print("placeholder")
////      case "Every Month":
////         print("placeholder")
////      case "Every Year":
////         print("placeholder")
////      default:
////         return 0
////      }
//   }
   
   func monthToInt() -> Int {
      switch self {
      case "Jan":
         return 1
      case "Feb":
         return 2
      case "Mar":
         return 3
      case "Apr":
         return 4
      case "May":
         return 5
      case "Jun":
         return 6
      case "Jul":
         return 7
      case "Aug":
         return 8
      case "Sep":
         return 9
      case "Oct":
         return 10
      case "Nov":
         return 11
      case "Dec":
         return 12
      default:
         fatalError("Unable to convert month: String to month: Int")
      }
   }
   
   func timeStringToDouble() -> Double {
      var decimalTime: String = ""
      var time: Double = 0
      for char in self {
         if char == String.Element(":") {
            decimalTime += "."
            continue
         }
         if char == String.Element(" ") {
            continue
         }
         if char == String.Element("A") {
            time = Double(decimalTime)!
            break
         }
         if char == String.Element("P") {
            time = Double(decimalTime)! + 12
            break
         }
      }
      return time
   }
   
   func convertColorString() -> UIColor {
      switch self {
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
