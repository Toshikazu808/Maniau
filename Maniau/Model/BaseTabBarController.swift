//
//  BaseTabBarController.swift
//  Maniau
//
//  Created by Ryan Kanno on 7/9/21.
//

import UIKit

class BaseTabBarController: UITabBarController {
   var scheduleItems: [ScheduledEvent] = []
   
   override func viewDidLoad() {
      super.viewDidLoad()
      print("\(#function) for BaseTabBarController")
   }
}
