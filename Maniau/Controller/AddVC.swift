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
   
   private var selectStartTimeVC = SelectStartTimeVC()
   private var selectEndTimeVC = SelectEndTimeVC()
   private var selectRepeatVC = SelectRepeatVC()
   private var selectAlertVC = SelectAlertVC()
   private var selectDateVC = SelectDateVC()
   private var event = ScheduledEvent(startTime: "4:00 PM", endTime: "5:00 PM", repeats: "Never", alert: "None", date: "Jun 24, 2021")
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      selectStartTimeVC.delegate = self
      selectEndTimeVC.delegate = self
      selectRepeatVC.delegate = self
      selectAlertVC.delegate = self
      selectDateVC.delegate = self
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let destination = segue.destination as? SelectStartTimeVC {
         destination.delegate = self
      } else if let destination = segue.destination as? SelectEndTimeVC {
         destination.delegate = self
      } else if let destination = segue.destination as? SelectRepeatVC {
         destination.delegate = self
      } else if let destination = segue.destination as? SelectAlertVC {
         destination.delegate = self
      } else if let destination = segue.destination as? SelectDateVC {
         destination.delegate = self
      }
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
      event.startTime = time
      startBtn.setTitle(event.startTime, for: .normal)
   }
}

extension AddVC: SelectEndTimeVCDelegate {
   func updateEndTime(time: String) {
      event.endTime = time
      endBtn.setTitle(event.endTime, for: .normal)
   }
}

extension AddVC: SelectRepeatVCDelegate {
   func updateRepeatSelection(repeatSelection: String) {
      repeatBtn.setTitle(repeatSelection, for: .normal)
      // Set notification for selected interval
   }
}

extension AddVC: SelectAlertVCDelegate {
   func updateAlertSelection(alertSelection: String) {
      alertBtn.setTitle(alertSelection, for: .normal)
      // Set notification for selected date / time
   }
}

extension AddVC: SelectDateVCDelegate {
   func updateSelectedDate() {
      
   }
}


