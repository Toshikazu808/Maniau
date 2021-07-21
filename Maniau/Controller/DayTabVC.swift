//
//  DayVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/23/21.
//

import UIKit

class DayTabVC: UIViewController {
   @IBOutlet weak var tableView: UITableView!
   private var data: [[ScheduledEvent]] = [[]]
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   override func viewWillAppear(_ animated: Bool) {
      self.tabBarController?.tabBar.isHidden = false
      K.daysWithEvents = Utilities.getDaysWithItems(from: K.thisMonthsSchedule)
      data = Utilities.createDataForTableView(using: K.daysWithEvents, toLoopThrough: K.thisMonthsSchedule)
      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(UINib(nibName: MonthTabCell.name, bundle: nil), forCellReuseIdentifier: MonthTabCell.name)
      tableView.reloadData()
   }
   override var shouldAutorotate: Bool { return false }
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
   override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
}

extension DayTabVC: UITableViewDelegate, UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
      return data.count
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return data[section].count
   }
   
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      return K.daysWithEvents[section]
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: MonthTabCell.name, for: indexPath) as! MonthTabCell
      cell.configure(
         color: data[indexPath.section][indexPath.row].color,
         title: data[indexPath.section][indexPath.row].title,
         details: data[indexPath.section][indexPath.row].description,
         start: data[indexPath.section][indexPath.row].startTime,
         end: data[indexPath.section][indexPath.row].endTime)
      return cell
   }
}
