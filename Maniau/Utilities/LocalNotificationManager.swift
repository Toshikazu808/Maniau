//
//  LocalNotificationManager.swift
//  Maniau
//
//  Created by Ryan Kanno on 8/25/21.
//

import UIKit
import UserNotifications

struct LocalNotificationManager {
   
   static func setNotification(for event: ScheduledEvent) {
      let content = getNotificationContent(for: event)
      let (request, id) = requestNotification(for: event, using: content)
      UNUserNotificationCenter.current().add(request) { error in
         if let error = error {
            print("Error setting UNNotificationRequest: \(error)")
         } else {
            print("LocalNotification ID: \(id)")
            // Add local notification uuid to
            // Defaults.notifications.setValue(id, forKey: Defaults.notificationsKey)   
         }
      }
   }
   
   static private func requestPermission() {
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
               print("UNUserNotificationCenter.current().requestAuthorization failed with error: \(error)")
               return
            }
            print("Local notification permission status: \(granted)")
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
   
   private static func requestNotification(for event: ScheduledEvent, using content: UNMutableNotificationContent) -> (UNNotificationRequest, String) {
      let time = calculateNotificationTimeInterval(for: event)
      let trigger = UNTimeIntervalNotificationTrigger(
         timeInterval: time,
         repeats: false)
      let uuidString = UUID().uuidString
      let request = UNNotificationRequest(
         identifier: uuidString,
         content: content,
         trigger: trigger)
      return (request, uuidString)
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
