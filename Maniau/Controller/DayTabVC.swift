//
//  DayVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/23/21.
//

import UIKit

class DayTabVC: UIViewController {
   @IBOutlet weak var tableView: UITableView!
   private var currentMonthsItems: [ScheduledEvent] = []
   private var days: [String] = []
   private var data: [[ScheduledEvent]] = [[]]
   
   override func viewDidLoad() {
      super.viewDidLoad()
      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(UINib(nibName: MonthTabCell.name, bundle: nil), forCellReuseIdentifier: MonthTabCell.name)
   }
   override func viewWillAppear(_ animated: Bool) {
      self.tabBarController?.tabBar.isHidden = false
   }
   override func viewDidAppear(_ animated: Bool) {      
      let tabbar = tabBarController as! BaseTabBarController
      currentMonthsItems = tabbar.scheduleItems
      print("\(#function) for DayTabVC")
      print("Retrieving data from BaseTabBarController")
      print("scheduleItems printing from BaseTabBarController: \(tabbar.scheduleItems)")
      days = Utilities.getDaysWithItems(from: currentMonthsItems)
      data = Utilities.createDataForTableView(using: days, toLoopThrough: currentMonthsItems)
      tableView.reloadData()
   }
   override func viewWillDisappear(_ animated: Bool) {
      let tabbar = tabBarController as! BaseTabBarController
      tabbar.scheduleItems = currentMonthsItems
      print("\(#function) for DayTabVC")
      print("Passing data to BaseTabBarController")
      print("scheduleItems printing from BaseTabBarController: \(tabbar.scheduleItems)")
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
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: DayTabCell.name, for: indexPath) as! DayTabCell
//      cell.configure(
//         color: data[indexPath.section][indexPath.row].color,
//         title: data[indexPath.section][indexPath.row].title,
//         details: data[indexPath.section][indexPath.row].description,
//         start: data[indexPath.section][indexPath.row].startTime,
//         end: data[indexPath.section][indexPath.row].endTime)
      return cell
   }
   
//   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//      return days[section]
//   }
}
