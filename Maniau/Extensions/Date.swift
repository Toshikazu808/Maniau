//
//  Date.swift
//  Maniau
//
//  Created by Ryan Kanno on 7/6/21.
//

import Foundation

extension Date {
   func formatDate() -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMM d, yyyy"
      return formatter.string(from: self)
   }
   
   func getRelevantMonth() -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM"
      return formatter.string(from: self)
   }
   
   func formatDayOfWeek() -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEEE"
      return formatter.string(from: self)
   }
   
   func getSelectedDay() -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "d"
      return formatter.string(from: self)
   }
}
