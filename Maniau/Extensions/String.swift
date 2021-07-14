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
      var hour: Double = 0
      var hourStr = ""
      var minuteStr = ""
      var hitDecimal = false
      
      for char in self {
         if !hitDecimal {
            if char == String.Element(":") {
               hour = Double(hourStr)!
               hitDecimal = true
            } else {
               hourStr += "\(char)"
            }
         } else {
            switch char {
            case String.Element(" "):
               break
            case String.Element("A"):
               if hour == 12 {
                  hour += 12
                  hourStr = String(format: "%.0f", hour)
               }
            case String.Element("P"):
               if hour != 12 {
                  hour += 12
                  hourStr = String(format: "%.0f", hour)
               }
            case String.Element("M"):
               break
            default:
               minuteStr += "\(char)"
            }
         }
      }
      let total = "\(hourStr).\(minuteStr)"
      return Double(total)!
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
