//
//  Utilities.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/22/21.
//

import UIKit
import FirebaseFirestore
import Firebase

struct Utilities {   
   static func extractEmail(from data: String) -> String {
      var email = data
      for char in email {
         if char == " " {
            email.removeFirst()
            break
         }
         email.removeFirst()
      }
      email.removeLast()
      return email
   }
   
   static func formatMinutes(num: Int) -> String {
      if num < 10 {
         return "0\(num)"
      } else {
         return "\(num)"
      }
   }
   
   static func setAlert(for event: ScheduledEvent) {
      let content = Utilities.setContent(event.title, event.description)
      let startDate = getStartDate(event.date, event.startTime)
      Utilities.requestNotification(with: content, and: startDate)
   }
   
   private static func setContent(_ title: String, _ description: String) -> UNMutableNotificationContent {
      let content = UNMutableNotificationContent()
      content.title = title
      content.body = description
      content.subtitle = ""
      content.sound = .default
      return content
   }
   
   private static func getStartDate(_ dateStr: String, _ startTime: String) -> Date {
      let date = Date()
      var components = DateComponents()
      let eventDate = Utilities.convertDate(date: dateStr)
      let eventHour = Utilities.convertStartTime(startTime: startTime)
      components.setValue(eventDate.month, for: .month)
      components.setValue(eventDate.day, for: .day)
      components.setValue(eventDate.year, for: .year)
      components.setValue(eventHour.hour, for: .hour)
      components.setValue(eventHour.minute, for: .minute)
      let expirationDate = Calendar.current.date(byAdding: components, to: date)
      return expirationDate!
   }
   
   private static func requestNotification(with content: UNMutableNotificationContent, and startDate: Date) {
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: startDate.timeIntervalSince1970, repeats: false)
      let uuidString = UUID().uuidString
      let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
      let center = UNUserNotificationCenter.current()
      center.add(request) { error in
         if let err = error {
            print(err)
         }
      }
   }
   
   private static func convertDate(date: String) -> (month: Int, day: Int, year: Int) {
      // ex. Jun 24, 2021
      var components: [String] = []
      var wordCount = 0
      for char in date {
         if char != " " {
            components[wordCount].append(String(char))
         } else {
            wordCount += 1
         }
      }
      let month = components[0].monthToInt()
      let day = Int(components[1])!
      let year = Int(components[2])!
      return (month, day, year)
   }
   
   private static func convertStartTime(startTime: String) -> (hour: Int, minute: Int) {
      // ex. 4:00 PM
      var components: [String] = []
      var timeCount = 0
      for char in startTime {
         if char != ":" && char != " " {
            components[timeCount].append(String(char))
         } else {
            timeCount += 1
         }
      }
      var hour = Int(components[0])!
      let minute = Int(components[1])!
      if components[2] == "PM" {
         hour += 12
      }
      if hour == 24 {
         hour = 0
      }
      return (hour, minute)
   }
   
   static func saveToFirebase(_ event: ScheduledEvent) -> Error? {
      var error: Error? = nil
      let id = Auth.auth().currentUser?.uid
      let path = Firestore.firestore().collection(K.fbUsers).document(id!)
      path.setData(Utilities.convertScheduled(event), merge: true) { err in
         if let err = err {
            print(err)
            error = err
         } else {
            print("Successfully updated document")
         }
      }
      return error
   }
   
   private static func convertScheduled(_ event: ScheduledEvent) -> [String: String] {
      let converted = [
         "title": event.title,
         "description": event.description,
         "startTime": event.startTime,
         "endTime": event.endTime,
         "repeats": event.repeats,
         "alert": event.alert,
         "date": event.date]
      return converted
   }
   
   static func logoutUser() {
      do {
         try Auth.auth().signOut()
         print("Signed out user")
         Defaults.autoLogin.removeObject(forKey: Defaults.autoLoginKey)
         Defaults.autoLogin.setValue(false, forKey: Defaults.autoLoginKey)
      } catch let signOutError as NSError {
         print("Error signing out: \(signOutError)")
      }
   }
}
