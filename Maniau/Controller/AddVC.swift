//
//  AddVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/23/21.
//

import UIKit
import FirebaseFirestore

class AddVC: UIViewController {
   @IBOutlet weak var titleTF: UITextField!
   @IBOutlet weak var descriptionTF: UITextField!
   @IBOutlet weak var allDay: UISwitch!
   @IBOutlet weak var dateBtn: UIButton!
   @IBOutlet weak var startBtn: UIButton!
   @IBOutlet weak var endBtn: UIButton!
   @IBOutlet weak var repeatBtn: UIButton!
   @IBOutlet weak var alertBtn: UIButton!
   
   let titlePlaceholder = "Title"
   let descriptionPlaceholder = "Description"
   var selectStartTimeVC = SelectStartTimeVC()
   var selectEndTimeVC = SelectEndTimeVC()
   var selectRepeatVC = SelectRepeatVC()
   var selectDateVC = SelectDateVC()
   var selectAlertVC = SelectAlertVC()
   
   var startTime = "4:00 PM"
   var endTime = "5:00 PM"
   var repeats = "Never"
   var alerts = "None"
   var startDate = "Jun 24, 2021"
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      selectStartTimeVC.delegate = self
      selectEndTimeVC.delegate = self
      selectRepeatVC.delegate = self
      selectDateVC.delegate = self
      selectAlertVC.delegate = self
   }
   
   @IBAction func saveTapped(_ sender: UIBarButtonItem) {
      // Save data to Firebase
      self.navigationController?.popViewController(animated: true)
   }
   
}


extension AddVC: UITextFieldDelegate {
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      switch textField {
      case titleTF:
         titleTF.endEditing(true)
         return true
      case descriptionTF:
         descriptionTF.endEditing(true)
         return true
      default:
         return false
      }
   }
}

extension AddVC: SelectStartTimeVCDelegate {
   func updateStartTime(time: String) {
      startTime = time
   }
}

extension AddVC: SelectEndTimeVCDelegate {
   func updateEndTime(time: String) {
      endTime = time
   }
}

extension AddVC: SelectRepeatVCDelegate {
   func updateRepeatSelection() {
      
   }
}

extension AddVC: SelectDateVCDelegate {
   func updateSelectedDate() {
      
   }
}

extension AddVC: SelectAlertVCDelegate {
   func updateAlertSelection() {
      
   }
}
