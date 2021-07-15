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
   
   static func convertScheduledToDict(_ event: ScheduledEvent) -> [String: String] {
      let converted = [
         "title": event.title,
         "description": event.description,
         "startTime": event.startTime,
         "endTime": event.endTime,
         "repeats": event.repeats,
         "alert": event.alert,
         "relevantMonth": event.relevantMonth,
         "date": event.date,
         "selectedDay": event.selectedDay,
         "dayOfWeek": event.dayOfWeek,
         "color": event.color]
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
   
   static func loadFromFirebase(viewController vc: UIViewController, database db: Firestore, date: Date, _ completion: @escaping ([ScheduledEvent]) -> Void ) {
      var events: [ScheduledEvent] = []
      let id = Auth.auth().currentUser!.uid
      
      db.collection(id).whereField("relevantMonth", isEqualTo: date.getRelevantMonth()).getDocuments { snapshot, error in
         if let error = error {
            DispatchQueue.main.async {
               vc.showError(error.localizedDescription)
            }
         } else if let snapshot = snapshot {
            DispatchQueue.main.async {
               events = Utilities.retrieveDocuments(from: snapshot)
               completion(events)
            }
         }
      }
   }
   
   private static func retrieveDocuments(from snapshot: QuerySnapshot) -> [ScheduledEvent] {
      var events: [ScheduledEvent] = []
      for document in snapshot.documents {
         let data = document.data() as! [String: String]
         let converted = Utilities.convertScheduleToStruct(data)
         events.append(converted)
      }
      return events
   }
   
   private static func convertScheduleToStruct(_ data: [String: String]) -> ScheduledEvent {
      let converted = ScheduledEvent(
         title: data["title"] ?? "title unavailable",
         description: data["description"] ?? "description unavailable",
         startTime: data["startTime"] ?? "startTime unavailable",
         endTime: data["endTime"] ?? "endTime unavailable",
         repeats: data["repeats"] ?? "repeat frequency unavailable",
         alert: data["alert"] ?? "alert time unavailable",
         relevantMonth: data["relevantMonth"] ?? "relevantMonth unavailable",
         date: data["date"] ?? "date unavailable",
         selectedDay: data["selectedDay"] ?? "selectedDay unavailable",
         dayOfWeek: data["dayOfWeek"] ?? "dayOfWeek unavailable",
         color: data["color"] ?? "color unavailable")
      return converted
   }
   
   static func getDaysWithItems(from schedule: [ScheduledEvent]) -> [String] {
      var days: [String] = []
      for i in 0..<schedule.count {
         if !days.contains(schedule[i].date) {
            days.append(schedule[i].date)
         }
      }
      return days
   }
   
   static func createDataForTableView(using days: [String], toLoopThrough scheduledEvent: [ScheduledEvent]) -> [[ScheduledEvent]] {
      var newArray = [[ScheduledEvent]]()
      for i in 0..<days.count {
         var subArray: [ScheduledEvent] = []
         for j in 0..<scheduledEvent.count {
            if days[i] == scheduledEvent[j].date {
               subArray.append(scheduledEvent[j])
            }
         }
         newArray.append(subArray)
      }
      return newArray
   }
   
   // MARK: - Merge Sort For This Month
   static func filterThisMonthsEvents(from schedule: [ScheduledEvent]) -> [ScheduledEvent] {
      var sortedSchedule: [ScheduledEvent] = schedule
      sortedSchedule = sortThisMonthsItems(items: sortedSchedule)
      return sortedSchedule
   }
   
   private static func sortThisMonthsItems(items: [ScheduledEvent]) -> [ScheduledEvent] {
      guard items.count > 1 else { return items }
      return mergeSortForThisMonth(items)
   }
   
   private static func mergeSortForThisMonth(_ array: [ScheduledEvent]) -> [ScheduledEvent] {
      guard array.count > 1 else { return array }
      let leftArray = Array(array[0..<array.count / 2])
      let rightArray = Array(array[array.count / 2..<array.count])
      return mergeForThisMonth(
         left: mergeSortForThisMonth(leftArray),
         right: mergeSortForThisMonth(rightArray))
   }
   
   private static func mergeForThisMonth(left: [ScheduledEvent], right: [ScheduledEvent]) -> [ScheduledEvent] {
      var mergedArray: [ScheduledEvent] = []
      var left = left
      var right = right
      while left.count > 0 && right.count > 0 {
         if left.first!.selectedDay.dayStringToDouble() > right.first!.selectedDay.dayStringToDouble() {
            mergedArray.append(left.removeFirst())
         } else {
            mergedArray.append(right.removeFirst())
         }
      }
      return mergedArray + left + right
   }
   
   // MARK: - Merge Sort For Today
   static func filterTodaysEvents(from scheduleItems: [ScheduledEvent], for date: Date) -> [ScheduledEvent] {
      var items: [ScheduledEvent] = []
      let selectedDay: String = date.getSelectedDay()
      for i in 0..<scheduleItems.count {
         if scheduleItems[i].selectedDay == selectedDay {
            items.append(scheduleItems[i])
         }
      }
      items = sortTodaysItems(items: items)
      return items
   }
   
   private static func sortTodaysItems(items: [ScheduledEvent]) -> [ScheduledEvent] {
      guard items.count > 1 else { return items }
      let sortedArray = mergeSortForToday(items)
      return rearrangeItems(compare: sortedArray, to: items)
   }
   
   private static func mergeSortForToday(_ array: [ScheduledEvent]) -> [ScheduledEvent] {
      guard array.count > 1 else { return array }
      let leftArray = Array(array[0..<array.count / 2])
      let rightArray = Array(array[array.count / 2..<array.count])
      return mergeForToday(
         left: mergeSortForToday(leftArray),
         right: mergeSortForToday(rightArray))
   }
   
   private static func mergeForToday(left: [ScheduledEvent], right: [ScheduledEvent]) -> [ScheduledEvent] {
      var mergedArray: [ScheduledEvent] = []
      var left = left
      var right = right
      while left.count > 0 && right.count > 0 {
         if left.first!.startTime.timeStringToDouble() < right.first!.startTime.timeStringToDouble() {
            mergedArray.append(left.removeFirst())
         } else {
            mergedArray.append(right.removeFirst())
         }
      }
      return mergedArray + left + right
   }
   
   private static func rearrangeItems(compare sortedArray: [ScheduledEvent], to originalArray: [ScheduledEvent]) -> [ScheduledEvent] {
      var rearranged: [ScheduledEvent] = []
      var j = 0
      while rearranged.count < originalArray.count {
         for i in 0..<originalArray.count {
            if sortedArray[j] == originalArray[i] {
               rearranged.append(originalArray[i])
               break
            }
         }
         j += 1
      }
      return rearranged
   }
}
