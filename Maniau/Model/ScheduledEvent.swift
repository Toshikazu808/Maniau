//
//  ScheduledEvent.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/25/21.
//

import Foundation

struct ScheduledEvent: Codable, Equatable {
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
   
   static func == (lhs: ScheduledEvent, rhs: ScheduledEvent) -> Bool {
      return lhs.title == rhs.title && lhs.description == rhs.description && lhs.startTime == rhs.startTime && lhs.endTime == rhs.endTime && lhs.repeats == rhs.repeats && lhs.alert == rhs.alert && lhs.relevantMonth == rhs.relevantMonth && lhs.date == rhs.date && lhs.selectedDay == rhs.selectedDay && lhs.dayOfWeek == rhs.dayOfWeek && lhs.color == rhs.color
   }
}
