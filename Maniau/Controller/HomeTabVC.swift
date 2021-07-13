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

class HomeTabVC: UIViewController {
   @IBOutlet private weak var calendar: FSCalendar!
   @IBOutlet private weak var tableView: UITableView!
   private let db = Firestore.firestore()
   private let selectedDate = Date()
   private var thisMonthsSchedule: [ScheduledEvent] = []
   private var todaysEvents: [ScheduledEvent] = []
   private var itemIndex = 0
   var email = ""
   
   override func viewDidLoad() {
      super.viewDidLoad()
      print("\(#function) for HomeTabVC")
      self.title = email
      calendar.delegate = self
      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(UINib(nibName: MonthTabCell.name, bundle: nil), forCellReuseIdentifier: MonthTabCell.name)
      Utilities.loadFromFirebase(viewController: self, database: db, date: selectedDate) { [weak self] retrievedSchedule in
         self?.thisMonthsSchedule = retrievedSchedule
         self?.todaysEvents = Utilities.filterTodaysEvents(from: self!.thisMonthsSchedule, for: self!.selectedDate)
      }
   }
   override func viewDidAppear(_ animated: Bool) {
      let tabbar = tabBarController as! BaseTabBarController
      thisMonthsSchedule = tabbar.scheduleItems
      print("\(#function) for HomeTabVC")
      print("Retrieving data from BaseTabBarController")
      print("scheduleItems printing from BaseTabBarController: \(tabbar.scheduleItems)")
   }
   override func viewWillDisappear(_ animated: Bool) {
      let tabbar = tabBarController as! BaseTabBarController
      tabbar.scheduleItems = thisMonthsSchedule
      print("\(#function) for HomeTabVC")
      print("Passing data to BaseTabBarController")
      print("scheduleItems printing from BaseTabBarController: \(tabbar.scheduleItems)")
   }
   override var shouldAutorotate: Bool { return false }
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
   override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let destination = segue.destination as? AddVC {
         destination.delegate = self
      } else if segue.destination is DetailsVC {
         let vc = segue.destination as? DetailsVC
         vc?.schedule = thisMonthsSchedule[itemIndex]
      } else if let destination = segue.destination as? DetailsVC {
         destination.delegate = self
      }
   }
   
   @IBAction private func logoutTapped(_ sender: UIBarButtonItem) {
      Utilities.logoutUser()
      self.dismiss(animated: true, completion: nil)
   }
}

extension HomeTabVC: FSCalendarDelegate {
   func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
      todaysEvents = Utilities.filterTodaysEvents(from: thisMonthsSchedule, for: date)
      tableView.reloadData()
   }
}

extension HomeTabVC: AddVCDelegate {
   func updateScheduleTable() {
      Utilities.loadFromFirebase(viewController: self, database: db, date: selectedDate) { [weak self] retrievedSchedule in
         self?.thisMonthsSchedule = retrievedSchedule
         self?.tableView.reloadData()
      }
   }
}

extension HomeTabVC: DetailsVCDelegate {
   func deleteAndUpdate() { // TODO
      print("Item deleted, update tableView")
   }
}

extension HomeTabVC: UITableViewDelegate, UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return thisMonthsSchedule.count
   }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 77
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(
         withIdentifier: MonthTabCell.name, for: indexPath) as! MonthTabCell
      cell.configure(
         color: todaysEvents[indexPath.row].color,
         title: todaysEvents[indexPath.row].title,
         details: todaysEvents[indexPath.row].description,
         start: todaysEvents[indexPath.row].startTime,
         end: todaysEvents[indexPath.row].endTime)
      return cell
   }

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      itemIndex = indexPath.row
      performSegue(withIdentifier: "toDetailsVC", sender: nil)
   }
}
