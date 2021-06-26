//
//  DateSelectorVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/23/21.
//

import UIKit

protocol SelectDateVCDelegate {
   func updateSelectedDate()
}

class SelectDateVC: UIViewController {
   var delegate: SelectDateVCDelegate?
   @IBOutlet weak var datePicker: UIDatePicker!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.tabBarController?.tabBar.isHidden = true
//      datePicker.datePickerMode = .date
   }
   
   
}
