//
//  String.swift
//  Maniau
//
//  Created by Ryan Kanno on 7/6/21.
//

import Foundation

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
}
