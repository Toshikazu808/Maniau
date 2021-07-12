//
//  Double.swift
//  Maniau
//
//  Created by Ryan Kanno on 7/12/21.
//

import Foundation

extension Double {
   func timeDoubleToString() -> String {
      let str = String(self)
      var numStr: String = ""
      for char in str {
         if char == String.Element(".") {
            numStr.append(":")
         } else {
            numStr.append("\(char)")
         }
      }
      return "\(numStr)"
   }
}
