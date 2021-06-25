//
//  SelectAlertVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/24/21.
//

import UIKit

protocol SelectAlertVCDelegate {
   func updateAlertSelection()
}

class SelectAlertVC: UIViewController {
   var delegate: SelectAlertVCDelegate?
   @IBOutlet weak var tableView: UITableView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      
   }
   
   @IBAction func saveTapped(_ sender: UIBarButtonItem) {
      
   }
   
}
