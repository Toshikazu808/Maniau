//
//  Extensions.swift
//  Maniau
//
//  Created by Ryan Kanno on 8/24/21.
//

import UIKit
import Firebase
import FirebaseAuth

// MARK: - UIViewController
extension UIViewController {
   func showError(_ error: String) {
      let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
      self.present(alert, animated: true)
   }
   
   func clearLoginTextFields(_ emailTF:  UITextField, _ pwTF: UITextField) {
      emailTF.text = ""
      emailTF.placeholder = "email"
      pwTF.text = ""
      pwTF.placeholder = "password"
   }
   
   func validateFields(_ email: String, _ password: String) -> String? {
      if email == "" {
         return "Please enter your email."
      }
      if password == "" {
         return "Please enter a password"
      }
      return nil
   }
   
   func askToSavePw() {
      let alert = UIAlertController(
         title: "Do you want to save your login information?",
         message: "Enabling automatic login will save your username and password to your device.",
         preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
         print("autoLogin set value to false")
      }))
      alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
         print("autoLogin set value to true")
      }))
      self.present(alert, animated: true)
   }
   
   func transitionToHome(_ email: String) {
      let tabVC = storyboard?.instantiateViewController(identifier: K.tabBarVC) as! UITabBarController
      if let vcs = tabVC.viewControllers,
         let navVC = vcs.first as? UINavigationController,
         let homeVC = navVC.topViewController as? HomeTabVC {
         homeVC.email = email
      }
      self.present(tabVC, animated: true, completion: nil)
   }
   
   func saveUserEmailToDefaults(_ email: String) {
      Defaults.userInfo.removeObject(forKey: Defaults.userInfoKey)
      Defaults.userInfo.setValue(email, forKey: Defaults.userInfoKey)
   }
   
   func displayLoading(with view: UIView, and indicator: UIActivityIndicatorView) {
      if indicator.isAnimating {
         indicator.stopAnimating()
         indicator.alpha = 0
         view.alpha = 0
      } else {
         view.alpha = 0.5
         indicator.alpha = 1
         indicator.startAnimating()
      }
   }
}

// MARK: - UIAlertController
extension UIAlertController {
   func show() {
      let window = UIWindow(frame: UIScreen.main.bounds)
      window.rootViewController = UIViewController()
      window.windowLevel = UIWindow.Level.alert
      window.makeKeyAndVisible()
      window.rootViewController?.present(self, animated: false, completion: nil)
   }
}

// MARK: - Date
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

// MARK: - String
extension String {
   func toSeconds() -> TimeInterval {
      let minute: Double = 60
      let day: Double = 86400
      
      switch self {
      case "5 minutes before":
         return minute * 5
      case "10 minutes before":
         return minute * 10
      case "15 minutes before":
         return minute * 15
      case "30 minutes before":
         return minute * 30
      case "1 hour before":
         return minute * 60
      case "2 hours before":
         return minute * 120
      case "1 day before":
         return day
      case "2 days before":
         return day * 2
      case "1 week before":
         return day * 7
      default:
         return 0
      }
   }
   
   func toTimeInterval() -> TimeInterval {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMM d, yyyy h:mm a" // ex. Jul 10, 2021 7:00 AM
      guard let formattedDate = formatter.date(from: self) else { fatalError() }
      return formattedDate.timeIntervalSince1970
   }
   
   func monthToInt() -> Int {
      switch self {
      case "Jan":
         return 1
      case "Feb":
         return 2
      case "Mar":
         return 3
      case "Apr":
         return 4
      case "May":
         return 5
      case "Jun":
         return 6
      case "Jul":
         return 7
      case "Aug":
         return 8
      case "Sep":
         return 9
      case "Oct":
         return 10
      case "Nov":
         return 11
      case "Dec":
         return 12
      default:
         fatalError("Unable to convert month: String to month: Int")
      }
   }
   
   func timeStringToDouble() -> Double {
      var hour: Double = 0
      var hourStr = ""
      var minuteStr = ""
      var hitDecimal = false
      
      for char in self {
         if !hitDecimal {
            if char == String.Element(":") {
               hour = Double(hourStr)!
               hitDecimal = true
            } else {
               hourStr += "\(char)"
            }
         } else {
            switch char {
            case String.Element(" "):
               break
            case String.Element("A"):
               if hour == 12 {
                  hour += 12
                  hourStr = String(format: "%.0f", hour)
               }
            case String.Element("P"):
               if hour != 12 {
                  hour += 12
                  hourStr = String(format: "%.0f", hour)
               }
            case String.Element("M"):
               break
            default:
               minuteStr += "\(char)"
            }
         }
      }
      let total = "\(hourStr).\(minuteStr)"
      return Double(total)!
   }
   
   func dayStringToDouble() -> Int {
      guard let num = Int(self) else { fatalError() }
      return num
   }
   
   func convertColorString() -> UIColor {
      switch self {
      case "Blue":
         return UIColor.systemBlue
      case "Teal":
         return UIColor.systemTeal
      case "Green":
         return UIColor.systemGreen
      case "Orange":
         return UIColor.systemOrange
      case "Red":
         return UIColor.systemRed
      case "Yellow":
         return UIColor.systemYellow
      case "Gray":
         return UIColor.systemGray
      default:
         return UIColor.systemTeal
      }
   }
}

// MARK: - Double
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
