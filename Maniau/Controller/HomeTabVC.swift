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
   static var thisMonthsSchedule: [ScheduledEvent] = []
   private var todaysEvents: [ScheduledEvent] = []
   private var itemIndex = 0
   var email = ""
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.title = email
      calendar.delegate = self
      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(
         UINib(nibName: MonthTabCell.name,bundle: nil),
         forCellReuseIdentifier: MonthTabCell.name)
      Utilities.loadFromFirebase(viewController: self, database: db, date: selectedDate) { [weak self] retrievedSchedule in
         guard let self = self else { return }
         HomeTabVC.thisMonthsSchedule = retrievedSchedule
         self.todaysEvents = Utilities.filterTodaysEvents(from: HomeTabVC.thisMonthsSchedule, for: self.selectedDate)
         self.tableView.reloadData()
      }
   }
   override func viewWillAppear(_ animated: Bool) {
      self.tabBarController?.tabBar.isHidden = false
      todaysEvents = Utilities.filterTodaysEvents(from: HomeTabVC.thisMonthsSchedule, for: selectedDate)
      tableView.reloadData()
   }
   override var shouldAutorotate: Bool { return false }
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
   override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let destination = segue.destination as? AddVC {
         destination.delegate = self
      } else if segue.destination is DetailsVC {
         let vc = segue.destination as? DetailsVC
         vc?.schedule = todaysEvents[itemIndex]
         print("vc?.schedule: \(String(describing: vc?.schedule))")
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
      todaysEvents = Utilities.filterTodaysEvents(from: HomeTabVC.thisMonthsSchedule, for: date)
      tableView.reloadData()
   }
}

extension HomeTabVC: AddVCDelegate {
   func updateScheduleTable() {
      Utilities.loadFromFirebase(viewController: self, database: db, date: selectedDate) { [weak self] retrievedSchedule in
         HomeTabVC.thisMonthsSchedule = retrievedSchedule
         DispatchQueue.main.async {
            self?.tableView.reloadData()
         }
      }
   }
}

extension HomeTabVC: DetailsVCDelegate {
   func deleteAndUpdate() {
      Utilities.loadFromFirebase(viewController: self, database: db, date: selectedDate) { [weak self] retrievedSchedule in
         HomeTabVC.thisMonthsSchedule = retrievedSchedule
         DispatchQueue.main.async {
            self?.tableView.reloadData()
         }
      }
   }
}

extension HomeTabVC: UITableViewDelegate, UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return todaysEvents.count
   }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableView.automaticDimension
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(
         withIdentifier: MonthTabCell.name,
         for: indexPath) as! MonthTabCell
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
      print("itemIndex: \(itemIndex)")
      performSegue(withIdentifier: K.toDetailsVC, sender: nil)
   }
}
