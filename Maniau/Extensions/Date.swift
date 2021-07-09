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
      formatter.dateFormat = "MMM dd, yyyy"
      return formatter.string(from: self)
   }
   
   func getRelevantMonth() -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM"
      return formatter.string(from: self)
   }
}
