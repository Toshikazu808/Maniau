//
//  HomeVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/22/21.
//

import UIKit
import FirebaseAuth
import FSCalendar
import Firebase

class HomeVC: UIViewController {
   @IBOutlet private weak var calendar: FSCalendar!
   @IBOutlet private weak var tableView: UITableView!
   private let db = Firestore.firestore()
   private let date = Date()
   private var scheduleItems: [ScheduledEvent] = []
   var email = ""
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.title = email
      calendar.delegate = self
      tableView.delegate = self
      tableView.dataSource = self
      scheduleItems = Utilities.loadFromFirebase(viewController: self, database: db, date: date)
   }
   override var shouldAutorotate: Bool { return false }
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
   override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let destination = segue.destination as? AddVC {
         destination.delegate = self
      }
   }
   
   @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
      Utilities.logoutUser()
      self.dismiss(animated: true, completion: nil)
   }
}

extension HomeVC: FSCalendarDelegate {
   func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
      print("date selected: \(date.formatDate())")
      
   }
}

extension HomeVC: AddVCDelegate {
   func updateScheduleTable(scheduleAdded: Bool) {
      if scheduleAdded {
         scheduleItems = Utilities.loadFromFirebase(viewController: self, database: db, date: date)
      }
   }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return scheduleItems.count
   }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 50
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: MonthTabCell.name, for: indexPath) as! MonthTabCell
      return cell
   }

//   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      <#code#>
//   }
}
