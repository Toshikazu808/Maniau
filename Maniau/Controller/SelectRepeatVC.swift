//
//  RepeatAlertTableVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/23/21.
//

import UIKit

protocol SelectRepeatVCDelegate {
   func updateRepeatSelection()
}

class SelectRepeatVC: UIViewController {
   var delegate: SelectRepeatVCDelegate?
   @IBOutlet weak var tableView: UITableView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   @IBAction func saveTapped(_ sender: UIBarButtonItem) {
   }
   
}
