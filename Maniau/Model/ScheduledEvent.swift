//
//  ScheduledEvent.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/25/21.
//

import Foundation

struct ScheduledEvent: Codable {
   var title: String
   var description: String
   var startTime: String
   var endTime: String
   var repeats: String
   var alert: String
   var relevantMonth: String
   var date: String // example: Jul 10, 2021
   var selectedDay: String
   var dayOfWeek: String
   var color: String
   
   func convertToDetailsArray() -> [String] {
      return [
         "\(self.date)",
         "\(self.startTime)",
         "\(self.endTime)",
         "\(self.repeats)",
         "\(self.alert)",
         "\(self.color)"]
   }
}
