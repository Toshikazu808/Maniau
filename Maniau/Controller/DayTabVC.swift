//
//  DayVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/23/21.
//

import UIKit

class DayTabVC: UIViewController {
   @IBOutlet weak var tableView: UITableView!
   private var scheduleItems: [ScheduledEvent] = []
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }
   override func viewWillAppear(_ animated: Bool) {
      let tabbar = tabBarController as! BaseTabBarController
      scheduleItems = tabbar.scheduleItems
      print("\(#function) for HomeTabVC")
      print("Retrieving data from BaseTabBarController")
      print("scheduleItems printing from BaseTabBarController: \(tabbar.scheduleItems)")
   }
   override func viewWillDisappear(_ animated: Bool) {
      let tabbar = tabBarController as! BaseTabBarController
      tabbar.scheduleItems = scheduleItems
      print("\(#function) for HomeTabVC")
      print("Passing data to BaseTabBarController")
      print("scheduleItems printing from BaseTabBarController: \(tabbar.scheduleItems)")
   }
   override var shouldAutorotate: Bool { return false }
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
   override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
   
   
}

//extension DayTabVC: UITableViewDelegate, UITableViewDataSource {
//   func numberOfSections(in tableView: UITableView) -> Int {
//      return 1
//   }
//
//   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//      <#code#>
//   }
//}
