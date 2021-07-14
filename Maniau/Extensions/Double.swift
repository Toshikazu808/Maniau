//
//  Double.swift
//  Maniau
//
//  Created by Ryan Kanno on 7/12/21.
//

import Foundation

extension Double {
   func timeDoubleToString() -> String {
      let hour: Double = self
      let time: (hour: Double, isAM: Bool) = determineHour(hour)
      
      let hourStr = String(format: "%.2f", time.hour)      
      return changeDecimalToTime(hourStr, time.isAM)
   }
   
   private func determineHour(_ hour: Double) -> (Double, Bool) {
      var hr = hour
      var isAM = true
      if hr >= 12 && hr < 24 {
         isAM = false
         if hr >= 13 {
            hr -= 12
         }
      }
      if hr >= 24 {
         hr -= 12
      }
      return (hr, isAM)
   }
   
   private func changeDecimalToTime(_ hourStr: String, _ isAM: Bool) -> String {
      var timeString: String = ""
      var hitDecimal = false
      var decimals = 0
      
      for char in hourStr {
         if char == String.Element(".") {
            timeString += ":"
            hitDecimal = true
         } else {
            timeString += "\(char)"
            if hitDecimal {
               decimals += 1
            }
         }
      }
      if decimals < 2 {
         timeString += "0"
      }
      if isAM {
         timeString += " AM"
      } else {
         timeString += " PM"
      }
      return timeString
   }
}
