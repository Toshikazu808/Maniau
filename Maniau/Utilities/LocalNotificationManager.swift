//
//  LocalNotificationManager.swift
//  Maniau
//
//  Created by Ryan Kanno on 8/25/21.
//

import UIKit
import UserNotifications

struct LocalNotificationManager {
   
   static func updateNotification(newEvent: ScheduledEvent, oldId: String) {
      deleteNotification(with: oldId)
      setNotification(for: newEvent)
   }
   
   static func deleteNotification(with id: String) {
      UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
   }
   
   static func setNotification(for event: ScheduledEvent) {
      let content = getNotificationContent(for: event)
      let request = requestNotification(for: event, using: content)
      UNUserNotificationCenter.current().add(request) { error in
         if let error = error {
            print("Error setting UNNotificationRequest: \(error)")
         } else {
            print("LocalNotification ID: \(event.id)")
         }
      }
   }
   
   static private func requestPermission() {
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
               print("UNUserNotificationCenter.current().requestAuthorization failed with error: \(error)")
            } else {
               print("Local notification permission status: \(granted)")
            }
         }
      }
   }

   private static func getNotificationContent(for event: ScheduledEvent) -> UNMutableNotificationContent {
      let content = UNMutableNotificationContent()
      content.title = event.title
      content.body = event.description
      content.subtitle = ""
      content.sound = UNNotificationSound.default
      content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
      return content
   }
   
   private static func requestNotification(for event: ScheduledEvent, using content: UNMutableNotificationContent) -> UNNotificationRequest {
      let time = calculateNotificationTimeInterval(for: event)
      let trigger = UNTimeIntervalNotificationTrigger(
         timeInterval: time,
         repeats: false)
      let request = UNNotificationRequest(
         identifier: event.id,
         content: content,
         trigger: trigger)
      return request
   }
   
   private static func calculateNotificationTimeInterval(for event: ScheduledEvent) -> TimeInterval {
      let eventDateString = "\(event.date) \(event.startTime)"
      let eventDate = eventDateString.toTimeInterval()
      let eventAlert = calculateAlertTimeInterval(eventDate, event.alert)
      return eventAlert
   }
   
   private static func calculateAlertTimeInterval(_ eventDate: TimeInterval, _ alert: String) -> TimeInterval {
      let secondsToSubtract = alert.toSeconds()
      return eventDate - secondsToSubtract
   }
   
}
