//
//  ScheduledEvent.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/25/21.
//

import Foundation

public struct ScheduledEvent: Codable {
   var title: String
   var description: String
   var startTime: String
   var endTime: String
   var repeats: String
   var alert: String
   var date: String
}
