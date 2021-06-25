//
//  HomeVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/22/21.
//

import UIKit
import FirebaseAuth
import FSCalendar

class HomeVC: UIViewController {
   @IBOutlet weak var calendar: FSCalendar!
   @IBOutlet weak var tableView: UITableView!
   let firebaseAuth = Auth.auth()
   
   let formatter = DateFormatter()
   let dateDays = Calendar.current.dateComponents([.day],
      from: Calendar.current.dateInterval(of: .month, for: Date())!.start,
      to: Calendar.current.dateInterval(of: .month, for: Date())!.end)
   
   var daysInMonth: String {
      var days = "\(dateDays)"
      var num = ""
      for char in days {
         if char == " " {
            days.removeFirst()
            break
         }
         days.removeFirst()
      }
      for char in days {
         if char != " " {
            num += "\(char)"
         } else {
            break
         }
      }
      return num
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      formatter.dateFormat = "EEEE MM-dd-YYYY"
      calendar.delegate = self
      print("days as string: \(daysInMonth)")
   }
   
   @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
      do {
         try firebaseAuth.signOut()
         print("Signed out user")
         self.navigationController?.popToRootViewController(animated: true)
      } catch let signOutError as NSError {
         print ("Error signing out: \(signOutError)")
      }
   }
   
}


extension HomeVC: FSCalendarDelegate {
   func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
      let dateString = formatter.string(from: date)
      print(dateString)
   }
}


//extension HomeVC: UITableViewDelegate, UITableViewDataSource {
//   func numberOfSections(in tableView: UITableView) -> Int {
//      <#code#>
//   }
//
//   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//      <#code#>
//   }
//
//   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//      <#code#>
//   }
//
//   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//      <#code#>
//   }
//
//   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      <#code#>
//   }
//
//}
