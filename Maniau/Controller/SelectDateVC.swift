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
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   
}
